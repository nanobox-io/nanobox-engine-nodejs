define(['./config', 'mout/object/merge', 'has'], function (config, merge, has) {

    'use strict';

    has.add('debug', true); // Set debug to true

    // Configuration file loaded by the framework while in the dev environment
    // Overrides for the dev environment goes here
    // This configuration can be used by any module by simply requiring 'app-config' while in the dev environment

    return merge(config, {
        env: 'dev',
        version: 0

        // ...
    });
});