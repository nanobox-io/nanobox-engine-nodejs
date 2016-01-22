define([
    'spoon/Controller'
], function (Controller) {

    'use strict';

    return Controller.extend({
        $name: '{{name}}Controller',

        /**
         * Constructor.
         */
        initialize: function () {
            Controller.call(this);

            // Do things here
        },

        /**
         * {@inheritDoc}
         */
        /*_onDestroy: function () {
            // Cancel timers, ajax requests and other stuff here
            // Note that linked child views/controllers are automatically destroyed
            // when this controller is destroyed
            Controller.prototype._onDestroy.call(this);
        }*/
    });
});
