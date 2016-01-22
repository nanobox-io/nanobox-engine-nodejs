/*jshint node:true, es5:true*/

'use strict';

module.exports = function (task) {
    task
    .id('install')
    .name('Project installation')
    .author('Indigo United')
    .description('Install project dependencies')
    .option('force', 'Force fetching of remote sources', false)

    .setup(function (opts, ctx, next) {
        opts.trailCmd = opts.force ? ' -f' : '';
        next();
    })

    .do('run', {
        description: 'Install client environment dependencies',
        options: {
            // TODO: bower should be called programatically?
            //       this would avoid having a global dependency on bower
            //       on the other hand.. its a good idea to force the user to install
            //       bower because it will be used as package manager for every project
            cmd: 'bower install{{trailCmd}}'
        }
    })
    .do('run', {
        description: 'Install node environment dependencies',
        options: {
            // TODO: should npm be called programatically?
            cmd: 'npm install{{trailCmd}}'
        }
    })
    .do('rm', {
        description: 'Cleanup files',
        options: {
            files: '.dejavurc'
        }
    });
};
