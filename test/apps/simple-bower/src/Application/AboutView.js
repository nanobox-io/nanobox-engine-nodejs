define([
    'spoon/View',
    'doT',
    'jquery',
    'text!./assets/tmpl/about.html',
    'css!./assets/css/about.css',
    'bootstrap'
], function (View, doT, $, tmpl) {

    'use strict';

    return View.extend({
        $name: 'AboutView',

        _element: 'div.about',
        _template: doT.template(tmpl),

        /**
         * {@inheritDoc}
         */
        render: function () {
            View.prototype.render.call(this);

            this._modalEl = this._element.find('.modal').modal();
            this._modalEl.on('hidden', function () {
                this._upcast('close');
            }.bind(this));
        },

        /**
         * {@inheritDoc}
         */
        _onDestroy: function () {
            this._modalEl.off().modal('hide');

            View.prototype._onDestroy.call(this);
        }
    });
});