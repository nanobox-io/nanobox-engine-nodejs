define([
    'spoon/Controller',
    './FooterView',
    'jquery'
], function (Controller, FooterView, $) {

    'use strict';

    return Controller.extend({
        $name: 'FooterController',

        /**
         * Constructor.
         */
        initialize: function () {
            Controller.call(this);

            this._view = this._link(new FooterView($('#footer')));
            this._view.render();
        }
    });
});