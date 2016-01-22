require([
    'Application/ApplicationController',
    'services/state',
    'jquery'
], function (ApplicationController, stateRegistry, $) {

    'use strict';

    $(document).ready(function () {
        // Initialize the Application controller
        var appController = new ApplicationController();

        // Listen to the state change event
        stateRegistry.on('change', appController.delegateState, appController);

        // Call parse() to make the state registry read the address value
        stateRegistry.parse();
    });
});
