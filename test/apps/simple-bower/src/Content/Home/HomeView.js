define([
    'spoon/View',
    'doT',
    'jquery',
    'text!./assets/tmpl/home.html',
    'css!./assets/css/home.css'
], function (View, doT, $, tmpl) {

    'use strict';

    return View.extend({
        $name: 'HomeView',

        _element: 'div.home',
        _template: doT.template(tmpl)
    });
});