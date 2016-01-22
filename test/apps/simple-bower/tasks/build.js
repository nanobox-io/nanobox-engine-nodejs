/*jshint node:true, es5:true, regexp:false*/

'use strict';

var fs        = require('fs');
var rjs       = require('requirejs');
var UglifyJS  = require('uglify-js');
var cleanCSS  = require('clean-css');
var gzip      = require('gzip-js');

module.exports = function (task) {
    task
    .id('build')
    .name('Build')
    .author('Indigo United')
    .description('Build project')
    .option('env', 'The environment to build', 'prod')

    .setup(function (opts, ctx, next) {
        // Validate environment
        if (opts.env === 'dev') {
            return next(new Error('dev environment can\'t be built'));
        }

        var cwd = process.cwd();
        fs.readFile(cwd + '/app/config/config_' + opts.env + '.js', function (err, contents) {
            if (err) {
                return next(new Error('Unknown environment: ' + opts.env));
            }

            // Expose the version in the opts
            var version = contents.toString().match(/["']?version['"]?\s*:\s*(\d+)/);
            if (!version) {
                return next(new Error('Could not increment version'));
            }
            opts.version = Number(version[1]) + 1;

            // Set some necessary vars to be used bellow
            opts.targetDir = cwd  + '/web/' + opts.env;
            opts.tempDir = cwd + '/tmp';
            opts.projectDir = cwd;

            ctx.log.writeln('Will build version ' + String(opts.version).green);
            next();
        });
    })

    .do('rm', {
        description: 'Clean up previous build',
        options: {
            files: ['{{tempDir}}', '{{targetDir}}']
        }
    })
    .do('mkdir', {
        description: 'Create build folder',
        options: {
            dirs: ['{{tempDir}}', '{{targetDir}}']
        }
    })
    .do('cp', {
        description: 'Copy necessary files to temporary folder',
        options: {
            files: {
                '{{projectDir}}/app/**/*': '{{tempDir}}/app/',
                '{{projectDir}}/src/**/*': '{{tempDir}}/src/',
                '{{projectDir}}/bower_components/**/*': '{{tempDir}}/bower_components/',
                '{{projectDir}}/*': '{{tempDir}}/'
            }
        }
    })
    .do('cp', {
        description: 'Copy necessary files to temporary folder',
        options: {
            files: {
                '{{projectDir}}/app/**/*': '{{tempDir}}/app/',
                '{{projectDir}}/src/**/*': '{{tempDir}}/src/',
                '{{projectDir}}/bower_components/**/*': '{{tempDir}}/bower_components/',
                '{{projectDir}}/*': '{{tempDir}}/'
            }
        }
    })
    .do(function (opts, ctx, next) {
        var loaderFile = opts.tempDir + '/app/loader.js';

        fs.readFile(loaderFile, function (err, contents) {
            if (err) {
                return next(err);
            }

            contents = contents.toString().replace(/\/app\/config\/config_\w+/g, '/app/config/config_' + opts.env);
            fs.writeFile(loaderFile, contents, next);
        });
    }, {
        description: 'Change target environment in loader config'
    })
    // TODO: create automaton task for this (requirejs)
    .do(function (opts, ctx, next) {
        rjs.optimize({
            // Loader settings
            mainConfigFile: opts.tempDir + '/app/loader.js',       // Include the main configuration file
            baseUrl: opts.tempDir + '/src',                        // Point to the tmp folder
            // r.js specific settings
            name: '../bower_components/almond/almond',                      // Use almond
            include: ['../app/loader', '../app/bootstrap'],
            out: opts.tempDir + '/app.js',
            has: {
                debug: false
            },
            optimize: 'none',
            separateCSS: true,
            stubModules: ['has', 'text', 'css', 'css/css', 'css/normalize']
        }, function (log) {
            ctx.log.info(log);
            next();
        }, function (err) {
            next(err);
        });
    }, {
        description: 'Run r.js optimizer'
    })
    // TODO: create automaton task for this (requirejs)
    .do(function (opts, ctx, next) {
        rjs.optimize({
            optimizeCss: 'standard.keepLines',
            cssIn: opts.tempDir + '/app.css',
            out: opts.tempDir + '/app.css',
            preserveLicenseComments: opts.licenses
        }, function (log) {
            ctx.log.write(log);

            // Replace trailing css from loader defs
            fs.readFile(opts.tempDir + '/app.js', function (err, contents) {
                if (err) {
                    return next(err);
                }

                contents = contents.toString().replace(/css!(.*?)\.css/g, 'css!$1');
                fs.writeFile(opts.tempDir + '/app.js', contents, next);
            });
        }, function (err) {
            next(err);
        });
    }, {
        description: 'Expand css files'
    })
    .do('mv', {
        description: 'Move assets to the build folder',
        options: {
            files: {
                '{{tempDir}}/src/**/assets/!(css|tmpl)/**/*': '{{targetDir}}/src/',
                '{{tempDir}}/app.js': '{{targetDir}}/app.js',
                '{{tempDir}}/app.css': '{{targetDir}}/app.css'
            }
        }
    })
    // TODO. create automaton task for cache busting or use scaffolding-replace with regexp support
    .do(function (opts, ctx, next) {
        var index = opts.projectDir + '/web/index_' + opts.env + '.html',
            css = opts.targetDir + '/app.css';

        // Update index file
        fs.readFile(index, function (err, contents) {
            if (err) {
                return next(err);
            }

            contents = contents
                .toString()
                .replace(/(app(?:\.min)?\.(?:css|js))(?:\?\d+)?/g, function (all, match) {
                    return match + '?' + opts.version;
                });

            fs.writeFile(index, contents, function (err) {
                if (err) {
                    return next(err);
                }

                // Update css file
                fs.readFile(css, function (err, contents) {
                    if (err) {
                        return next(err);
                    }

                    contents = contents
                        .toString()
                        .replace(/(url\s*\(["']?)(.*?)(["']?\))/ig, function (match, start, url, end) {
                            url = start + url.split('?', 2)[0] + '?' + opts.version + end;
                            return url;
                        });

                    fs.writeFile(css, contents, next);
                });
            });
        });
    }, {
        description: 'Apply cache busting'
    })
    // TODO: create automaton task for this (minjs)
    .do(function (opts, ctx, next) {
        // TODO: minified also contains a .map with the source mappings
        //       investigate how to integrate it!
        var minified = UglifyJS.minify(opts.targetDir + '/app.js'),
            minifiedSize = String(minified.code.length),
            gzipSize = String(gzip.zip(minified.code, {}).length);

        ctx.log.writeln('Compressed size: ' + gzipSize.green + ' bytes gzipped (' + minifiedSize.green + ' bytes minified).');

        fs.writeFile(opts.targetDir + '/app.min.js', minified.code, next);
    }, {
        description: 'Minify js file'
    })
    // TODO: create automaton task for this (mincss)
    .do(function (opts, ctx, next) {
        fs.readFile(opts.targetDir + '/app.css', function (err, contents) {
            if (err) {
                return next(err);
            }

            var minified = cleanCSS.process(contents.toString(), opts),
                minifiedSize = String(minified.length),
                gzipSize = String(gzip.zip(minified, {}).length);

            ctx.log.writeln('Compressed size: ' + gzipSize.green + ' bytes gzipped (' + minifiedSize.green + ' bytes minified).');

            fs.writeFile(opts.targetDir + '/app.min.css', minified, next);
        });
    }, {
        description: 'Minify css file'
    })
    .do(function (opts, ctx, next) {
        var configFile = opts.projectDir + '/app/config/config_' + opts.env + '.js';
        fs.readFile(configFile, function (err, contents) {
            if (err) {
                return next(err);
            }

            // Update the version in the config
            contents = contents.toString().replace(/(["']?version['"]?\s*:\s*)\d+/, function (all, match) {
                return match + opts.version;
            });

            fs.writeFile(configFile, contents, next);
        });
    }, {
        description: 'Save version number'
    })
    .do('rm', {
        description: 'Clean up temporary files',
        options: {
            files: '{{tempDir}}'
        }
    });
};
