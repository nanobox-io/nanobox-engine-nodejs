define([
    'spoon/Controller',
    './HeaderView',
    'jquery'
], function (Controller, HeaderView, $) {

    'use strict';

    return Controller.extend({
        $name: 'HeaderController',

        /**
         * Constructor.
         */
        initialize: function () {
            Controller.call(this);

            this._view = this._link(new HeaderView($('#header')));
            this._view.render();
        }
    });
});