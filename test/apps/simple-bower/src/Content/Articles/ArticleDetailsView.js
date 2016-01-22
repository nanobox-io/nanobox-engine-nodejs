define([
    'spoon/View',
    'doT',
    'jquery',
    'text!./assets/tmpl/details.html',
    'css!./assets/css/articles.css'
], function (View, doT, $, tmpl) {

    'use strict';

    return View.extend({
        $name: 'ArticleDetailsView',

        _element: 'div.article-details',
        _template: doT.template(tmpl),

        // Handlers can also be anonymous functions
        _events: {
            'click .back': '_onBackClick'
        },

        /**
         * Handles the back button click.
         */
        _onBackClick: function (event, element) {
            console.log('Click the back button', element);
            this._upcast('back');
        }
    });
});