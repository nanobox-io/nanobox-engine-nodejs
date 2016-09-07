define(function () {

    'use strict';

    // Declaration of states and their routes
    // This is actually not necessary if you don't have routes associated to states
    // But it is a good practice to do so, because it gives an overview of all the application states
    return {
        home: '/',
        articles: {
            index: '/',
            // Just to demonstrate some advanced stuff
            show: {
                $pattern: '/{id}',
                $constraints: {
                    id: /\d+/
                }
            }
        },
        help: '/help',
        about: '/about'
    };
});