/*jshint node:true, es5:true*/

'use strict';

var path  = require('path');
var utils = require('mout');
var fs    = require('fs');

module.exports = function (task) {
    task
    .id('spoon-controller-create')
    .name('SpoonJS controller create')
    .author('Indigo United')
    .description('Create controller')
    .option('name', 'The name of the controller')
    .option('force', 'Force the creation of the controller, even if it already exists', false)

    .setup(function (opts, ctx, next) {
        // Get the location in which the the module will be created
        var cwd = path.normalize(process.cwd()),
            location = path.dirname(opts.name),
            target;

        // Extract only the basename
        opts.name = path.basename(opts.name);

        // Validate name
        if (/[^a-z0-9_\-\.]/i.test(opts.name)) {
            return next(new Error('"' + opts.name + '" contains unallowed chars'));
        }

        // Trim trailing controller and generate a suitable name
        opts.name = path.basename(opts.name.replace(/([_\-]?controller)$/i, ''), '.js') || 'Controller';
        opts.name = utils.string.pascalCase(opts.name.replace(/_/g, '-'));

        if (location === '.') {
            return next(new Error('Please specify a folder for the controller (e.g. Application/' + opts.name + ')'));
        }
        if (location.charAt(0) !== '/') {
            location = '/src/' + location;
        }

        opts.dir = path.join(cwd, location);
        opts.__dirname = __dirname;

        // Check if create already exists
        target = path.join(opts.dir, opts.name + 'Controller.js');
        if (!opts.force) {
            fs.stat(target, function (err) {
                if (!err || err.code !== 'ENOENT') {
                    return next(new Error('"' + target + '" already exists'));
                }

                return next();
            });
        } else {
            next();
        }
    })

    .do('cp', {
        description: 'Copy the controller directory',
        options: {
            files: {
                '{{__dirname}}/controller_structure/**/*' : '{{dir}}'
            }
        }
    })
    .do('scaffolding-file-rename', {
        description: 'Rename files according to the name of the controller',
        options: {
            files: '{{dir}}/**/*',
            data: {
                name: '{{name}}'
            }
        }
    })
    .do('scaffolding-replace', {
        description: 'Set up controller',
        options: {
            files: '{{dir}}/**/*.+(css|html|js)',
            data: {
                name: '{{name}}'
            }
        }
    });
};
