define([
    'spoon/Controller',
    './HelpView'
], function (Controller, HelpView) {

    'use strict';

    return Controller.extend({
        $name: 'HelpController',

        /**
         * Constructor.
         */
        initialize: function () {
            Controller.call(this);

            this._view = this._link(new HelpView());
            this._view.appendTo('#content');
            this._view.render();
        }
    });
});