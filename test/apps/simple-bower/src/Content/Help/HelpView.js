define([
    'spoon/View',
    'doT',
    'jquery',
    'text!./assets/tmpl/help.html',
    'css!./assets/css/help.css'
], function (View, doT, $, tmpl) {

    'use strict';

    return View.extend({
        $name: 'HelpView',

        _element: 'div.help',
        _template: doT.template(tmpl)
    });
});