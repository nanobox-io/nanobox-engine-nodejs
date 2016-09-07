define(['./config', 'mout/object/merge'], function (config, merge) {

    'use strict';

    // Configuration file loaded by the framework while in the prod environment
    // Overrides for the prod environment goes here
    // This configuration can be used by any module by simply requiring 'app-config' while in the prod environment

    return merge(config, {
        env: 'prod',
        version: 0,

        // Address overrides
        address: {
            html5: true         // Setup prettier URLs by enabling HTML5
                                // If changed to true, the server needs to be able to rewrite URLs to the front controller
        }
    });
});