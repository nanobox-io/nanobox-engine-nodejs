define([
    'spoon/Controller',
    './MenuView',
    'jquery'
], function (Controller, MenuView, $) {

    'use strict';

    return Controller.extend({
        $name: 'MenuController',

        /**
         * Constructor.
         */
        initialize: function () {
            Controller.call(this);

            this._view = this._link(new MenuView($('#menu')));
            this._view.render();

            // Listen to the broadcast event in order select the menu item accordingly
            this.on('app.content_change', this.setSelected);
        },

        /**
         * Sets the current selected menu item.
         *
         * @param {String} key The menu key
         *
         * @return {MenuController} The instance itself to allow chaining
         */
        setSelected: function (key) {
            this._view.setSelected(key);

            return this;
        }
    });
});