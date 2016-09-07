define([
    'spoon/Controller',
    './HomeView'
], function (Controller, HomeView) {

    'use strict';

    return Controller.extend({
        $name: 'HomeController',

        _view: null,

        ////////////////////////////////////////////////////////////

        /**
         * Constructor.
         */
        initialize: function () {
            Controller.call(this);

            this._view = this._link(new HomeView());
            this._view.appendTo('#content');
            this._view.render();
        }
    });
});