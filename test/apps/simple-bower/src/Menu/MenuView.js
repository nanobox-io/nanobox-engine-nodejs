define([
    'spoon/View',
    'doT',
    'text!./assets/tmpl/menu.html',
    'css!./assets/css/menu.css'
], function (View, doT, tmpl) {

    'use strict';

    return View.extend({
        $name: 'MenuView',

        _template: doT.template(tmpl),

        /**
         * Sets the current selected menu item.
         *
         * @param {String} key The menu key
         *
         * @return {MenuView} The instance itself to allow chaining
         */
        setSelected: function (key) {
            if (this._currentSelected) {
                this._currentSelected.removeClass('active');
            }

            this._currentSelected = this._element.find('.' + key).addClass('active');
        }
    });
});