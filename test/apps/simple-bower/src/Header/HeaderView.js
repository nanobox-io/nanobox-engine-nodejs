define([
    'spoon/View',
    'doT',
    'text!./assets/tmpl/header.html',
    'css!./assets/css/header.css'
], function (View, doT, tmpl) {

    'use strict';

    return View.extend({
        $name: 'HeaderView',

        _template: doT.template(tmpl)
    });
});