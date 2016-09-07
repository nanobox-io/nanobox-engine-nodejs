/*jshint node:true, es5:true, latedef:false*/

'use strict';

var fs      = require('fs');
var path    = require('path');
var express = require('express');
var connect = require('connect');

module.exports = function (task) {
    task
    .id('server')
    .name('Server')
    .author('Indigo United')
    .description('Run server')
    .option('env', 'The environment that the server will run', 'dev')
    .option('port', 'The port to listen for requests', 8080)
    .option('host', 'The host to listen for requests', '127.0.0.1')

    .setup(function (options, ctx, next) {
        options.index = './index_' + options.env + '.html';
        options.assetsDir = options.env;

        if (options.env !== 'dev') {
            options.rewrite = true;
            options.gzip = true;
        }

        next();
    })

    .do(function (options, ctx, next) {
        // Change cwd to the web folder
        process.chdir('web');

        var web = process.cwd(),
            env = options.env,
            link;

        // Check if the env is valid
        try {
            fs.statSync(options.index);
        } catch (e) {
            if (e.code === 'ENOENT') {
                return next(new Error('Invalid environment: ' + env));
            }
        }

        options.web = web;

        // Create dev symlink
        if (options.env === 'dev') {
            try {
                link = fs.readlinkSync('dev');
            } catch (e) {}

            if (!link || link !== '..') {
                try {
                    fs.unlinkSync('dev');
                } catch (e) {}

                // In windows, users can't create symlinks in the console
                // without running the actual command with Administrator permissions
                // see: http://ahtik.com/blog/2012/08/16/fixing-your-virtualbox-shared-folder-symlink-error
                if (process.platform === 'win32') {
                    try {
                        fs.symlinkSync('..', 'dev', 'dir');
                    } catch (e) {
                        if (e.code === 'EPERM') {
                            return next(new Error('No permission to create symlink (try running as an Administrator).'));
                        }
                    }
                } else {
                    fs.symlinkSync('..', 'dev', 'dir');
                }
            }
        // Check assets dir
        } else {
            try {
                fs.statSync(options.assetsDir);
            } catch (e) {
                if (e.code === 'ENOENT') {
                    return next(new Error('Directory "' + options.assetsDir + '" not found, did you forgot to build?'));
                }
            }
        }

        next();
    }, {
        description: 'Prepare server'
    })
    .do(function (opts, ctx) {
        // Check if assets dir exists
        var site = express();

        // Enable compression?
        if (opts.gzip) {
            site.use(connect.compress());
        }

        // Serve index
        site.get('/', function (req, res) {
            return res.sendfile(opts.index);
        });

        // Serve favicon.ico
        site.use(express.favicon('./favicon.ico'));


        // Serve files & folders
        site.get('/*', function (req, res) {
            // Get the requested file
            // If there are query parameters, remove them
            var file = path.join(opts.web, req.url.substr(1));
            file = file.split('?')[0];

            fs.stat(file, function (err, stat) {
                // If file does not exists, serve 404 page
                if (err && err.code === 'ENOENT') {
                    serve404(opts, res);
                // If it exists and is a file, serve it
                } else if (stat.isFile()) {
                    res.sendfile(file);
                // Otherwise is a folder, so we deny the access
                } else {
                    res.send(403);
                }
            });
        });

        // Effectively listen
        site.listen(opts.port, opts.host);
        ctx.log.writeln('Listening on http://' + (opts.host === '127.0.0.1' ? 'localhost' : opts.host) + ':' + opts.port + ' (' + opts.env + ' environment)');
    }, {
        description: 'Serve files'
    });
};

/**
 * Serve 404 page.
 *
 * @param {Object} The task options
 * @param {Object} The express response object
 */
function serve404(options, res) {
    // If the rewrite is disabled, we attempt to serve the 404.html page
    // Otherwise we rewrite to the front controller (index)
    if (!options.rewrite) {
        var file404 = path.join(options.web, '404.html');
        fs.stat(file404, function (err) {
            if (!err) {
                res.status(404);
                res.sendfile('404.html');
            } else {
                res.send(404);
            }
        });
    } else {
        res.sendfile(options.index);
    }
}
