define(['./states'], function (states) {

    'use strict';

    // This is the base configuration file
    // Define the framework options here as well as application specific ones

    return {
        // Address configuration
        address: {
            basePath: '/',
            html5: false,     // Disable HTML5 address because it needs the correct base path and mod rewrite activated
            translate: true   // Translate from HTML5 URLs to hash automatically (and vice-versa)
        },

        // State configuration
        state: {
            routing: true,  // Enable or disable routing (even with the routing disabled the application will work as expected)
            states: states  // States are imported from another file
        }
    };
});