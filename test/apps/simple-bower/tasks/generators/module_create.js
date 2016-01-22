/*jshint node:true, es5:true*/

'use strict';

var path  = require('path');
var utils = require('mout');
var fs    = require('fs');

module.exports = function (task) {
    task
    .id('spoon-module-create')
    .name('SpoonJS module create')
    .author('Indigo United')
    .description('Create module')
    .option('name', 'The name of the module')
    .option('force', 'Force the creation of the module, even if it already exists', false)

    .setup(function (opts, ctx, next) {
        // Get the location in which the the module will be created
        var cwd = path.normalize(process.cwd()),
            location = path.dirname(opts.name);

        // Extract only the basename
        opts.name = path.basename(opts.name, '.js');

        // Validate name
        if (/[^a-z0-9_\-\.]/i.test(opts.name)) {
            return next(new Error('"' + opts.name + '" contains unallowed chars'));
        }

        // Generate suitable names
        opts.name = utils.string.pascalCase(opts.name.replace(/_/g, '-'));
        opts.underscoredName = utils.string.underscore(opts.name);

        if (location.charAt(0) !== '/') {
            location = '/src/' + location;
        }

        opts.dir = path.join(cwd, location, opts.name);
        opts.__dirname = __dirname;

        // Check if module already exists
        if (!opts.force) {
            fs.stat(opts.dir, function (err) {
                if (!err || err.code !== 'ENOENT') {
                    return next(new Error('"' + opts.name + '" already exists'));
                }

                return next();
            });
        } else {
            next();
        }
    })

    .do('cp', {
        description: 'Copy the structure of the module',
        options: {
            files: {
                '{{__dirname}}/module_structure/**/*' : '{{dir}}'
            },
            glob: {
                dot: true
            }
        }
    })
    .do('scaffolding-file-rename', {
        description: 'Rename files based on the name of the module',
        options: {
            files: '{{dir}}/**/*',
            data: {
                name: '{{name}}',
                underscoredName: '{{underscoredName}}'
            }
        }
    })
    .do('scaffolding-replace', {
        description: 'Set up files',
        options: {
            files: '{{dir}}/**/*.+(css|html|js)',
            data: {
                name: '{{name}}',
                underscoredName: '{{underscoredName}}'
            }
        }
    })
    .do('rm', {
        description: 'Cleanup dummy files',
        options: {
            files: '{{dir}}/**/.gitkeep'
        }
    });
};
