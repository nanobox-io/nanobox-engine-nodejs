define([
    'spoon/View',
    'doT',
    'text!./assets/tmpl/list.html',
    'css!./assets/css/articles.css'
], function (View, doT, tmpl) {

    'use strict';

    return View.extend({
        $name: 'ArticlesListView',

        _element: 'div.articles-list',
        _template: doT.template(tmpl),

        _events: {
            'click tr': '_onClick',
            'mouseenter tr a': '_onMouseEnter',
            'mouseleave tr a': '_onMouseLeave'
        },

        /**
         * Handles the row click.
         */
        _onClick: function (event, element) {
            console.log('Click tr of element #' + element.data('id'), element);
        },

        /**
         * Handles the row mouse enter.
         */
        _onMouseEnter: function (event, element) {
            console.log('Enter link of element #' + element.closest('tr').data('id'), element);
        },

        /**
         * Handles the row mouse leave.
         */
        _onMouseLeave: function (event, element) {
            console.log('Leave link of element #' + element.closest('tr').data('id'), element);
        }
    });
});