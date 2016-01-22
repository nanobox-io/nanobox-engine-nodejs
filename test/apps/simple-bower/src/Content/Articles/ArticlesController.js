define([
    'spoon/Controller',
    './ArticlesListView',
    './ArticleDetailsView'
], function (Controller, ArticlesListView, ArticleDetailsView) {

    'use strict';

    return Controller.extend({
        $name: 'ArticlesController',

        _defaultState: 'index',
        _states: {
            'index': '_indexState',
            'show(id)': '_showState'
        },

        _mockData: [
            {
                id: 1,
                title: 'First article',
                text: 'Some content for the first article'
            },
            {
                id: 2,
                title: 'Second article',
                text: 'Some content for the second article'
            },
            {
                id: 3,
                title: 'Third article',
                text: 'Some content for the third article'
            }
        ],

        /**
         * Index state handler.
         *
         * @param {Object} state The state parameter bag
         */
        _indexState: function (state) {
            this._destroyView();
            this._view = this._link(new ArticlesListView());
            this._view.appendTo('#content');
            this._view.render({ articles: this._mockData });
        },

        /**
         * Show state handler.
         *
         * @param {Object} state The state parameter bag
         */
        _showState: function (state) {
            var id = state.id;

            if (!this._mockData[id - 1]) {
                console.log('Unkown article!');
                this._indexState();
            } else {
                this._destroyView();
                this._view = this._link(new ArticleDetailsView());
                this._view.appendTo('#content');
                this._view.render({ article: this._mockData[id - 1] });

                // Handle the back event
                this._view.on('back', function () {
                    this.setState('index', null, { replace: true });
                }.bind(this));
            }
        },

        /**
         * Destroy the current view if any.
         */
        _destroyView: function () {
            if (this._view) {
                this._view.destroy();
                this._view = null;
            }
        }
    });
});