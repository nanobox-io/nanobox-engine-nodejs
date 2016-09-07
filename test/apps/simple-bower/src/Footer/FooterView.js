define([
    'spoon/View',
    'doT',
    'text!./assets/tmpl/footer.html',
    'css!./assets/css/footer.css'
], function (View, doT, tmpl) {

    'use strict';

    return View.extend({
        $name: 'FooterView',

        _template: doT.template(tmpl)
    });
});