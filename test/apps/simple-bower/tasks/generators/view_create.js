/*jshint node:true, es5:true*/

'use strict';

var path  = require('path');
var utils = require('mout');
var fs    = require('fs');

module.exports = function (task) {
    task
    .id('spoon-view-create')
    .name('SpoonJS view create')
    .author('Indigo United')
    .description('Create view')
    .option('name', 'The name of the view')
    .option('force', 'Force the creation of the view, even if it already exists', false)

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

        // Trim trailing view and generate suitable names
        opts.name = path.basename(opts.name.replace(/([_\-]?view)$/i, ''), '.js') || 'View';
        opts.name = utils.string.pascalCase(opts.name.replace(/_/g, '-'));
        opts.underscoredName = utils.string.underscore(opts.name);

        if (location === '.') {
            return next(new Error('Please specify a folder for the view (e.g. Application/' + opts.name + ')'));
        }
        if (location.charAt(0) !== '/') {
            location = '/src/' + location;
        }

        opts.dir = path.join(cwd, location);
        opts.__dirname = __dirname;

        // Check if create already exists
        target = path.join(opts.dir, opts.name + 'View.js');
        if (!opts.force) {
            fs.stat(target, function (err) {
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
        description: 'Copy the view directory',
        options: {
            files: {
                '{{__dirname}}/view_structure/**/*' : '{{dir}}'
            },
            glob: {
                dot: true
            }
        }
    })
    .do('scaffolding-file-rename', {
        description: 'Rename files according to the name of the view',
        options: {
            files: '{{dir}}/**/*',
            data: {
                name: '{{name}}',
                underscoredName: '{{underscoredName}}'
            }
        }
    })
    .do('scaffolding-replace', {
        description: 'Set up view',
        options: {
            files: '{{dir}}/**/*.+(css|html|js)',
            data: {
                name: '{{name}}',
                underscoredName: '{{underscoredName}}'
            }
        }
    });
};
