define([
    'spoon/View',
    'jquery',
    'doT',
    'text!./assets/tmpl/{{underscoredName}}.html',
    'css!./assets/css/{{underscoredName}}.css'
], function (View, $, doT, tmpl) {

    'use strict';

    return View.extend({
        $name: '{{name}}View',

        _template: doT.template(tmpl)
        /*_events: {
            'click .btn': '_onBtnClick'
        },*/

        /**
         * {@inheritDoc}
         */
        /*render: function (data) {
            // By default, the render function already
            // renders the template with the passed data
            View.prototype.render.call(this, data);

            // Do other things here

            return this;
        },*/

        /**
         * Handles the button click event.
         *
         * @param {Event} event The event
         */
        /*_onBtnClick: function (event) {
            this._upcast('btn-click');
        },*/

        /**
         * {@inheritDoc}
         */
        /*_onDestroy: function () {
            // Cancel timers and other stuff here
            // Note that linked child views/controllers are automatically destroyed
            // when this view is destroyed
            // The view element is also destroyed, clearing all the events and other stuff
            // from its element and its descendants
            View.prototype._onDestroy.call(this);
        }*/
    });
});
