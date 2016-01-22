/*global requirejs*/

requirejs.config({
    baseUrl: './dev/src',
    paths: {
        'mout': '../bower_components/mout/src',
        'events-emitter': '../bower_components/events-emitter/src',
        'address': '../bower_components/address/src',
        'jquery': '../bower_components/jquery/jquery',
        'doT': '../bower_components/doT/doT',
        'text': '../bower_components/requirejs-text/text',
        'has': '../bower_components/has/has',
        'bootstrap': '../bower_components/bootstrap/js/bootstrap',
        'bootstrap-css': '../bower_components/bootstrap/css'
    },
    shim: {
        'handlebars': {
            exports: 'Handlebars'
        }
    },
    map: {
        '*': {
            // App config (defaults to dev but changes during build)
            'app-config': '../app/config/config_dev',

            // Spoon
            'spoon': '../bower_components/spoonjs/src/index',

            // Spoon aliases
            'spoon/Controller': '../bower_components/spoonjs/src/core/Controller',
            'spoon/View': '../bower_components/spoonjs/src/core/View',

            // Spoon services
            'services/broadcaster': '../bower_components/spoonjs/src/core/Broadcaster/BroadcasterFactory',
            'services/address': '../bower_components/spoonjs/src/core/Address/AddressFactory',
            'services/state': '../bower_components/spoonjs/src/core/StateRegistry/StateRegistryFactory'
        }
    },
    packages: [
        // CSS plugin
        {
            name: 'css',
            location: '../bower_components/require-css',
            main: 'css'
        }
    ]
});
