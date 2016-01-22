define([
    'spoon/Controller',
    './ApplicationView',
    './AboutView',
    '../Header/HeaderController',
    '../Footer/FooterController',
    '../Menu/MenuController',
    '../Content/Home/HomeController',
    '../Content/Articles/ArticlesController',
    '../Content/Help/HelpController'
], function (Controller, ApplicationView, AboutView, HeaderController, FooterController, MenuController, HomeController, ArticlesController, HelpController) {

    'use strict';

    return Controller.extend({
        $name: 'ApplicationController',

        _defaultState: 'home',
        _states: {
            'home': '_homeState',
            'articles': '_articlesState',
            'help': '_helpState',
            'about': '_aboutState'
        },

        /**
         * Constructor.
         */
        initialize: function () {
            Controller.call(this);

            // Instantiate and render the application view
            this._view = this._link(new ApplicationView());
            this._view.appendTo(document.body);
            this._view.render();

            // Instantiate and link the header footer and menu
            this._header = this._link(new HeaderController());
            this._footer = this._link(new FooterController());
            this._menu = this._link(new MenuController());
        },

        /**
         * Home state handler.
         *
         * @param {Object} state The state parameter bag
         */
        _homeState: function (state) {
            this._destroyContent();
            this._content = this._link(new HomeController());
            this._content.delegateState(state);

            // Broadcast the content change (will be caught by the menu to select the current item)
            // This was actually unecessary because we could do this._menu.setSelected('home') instead
            // But it was a way to demonstrate the broadcast functionality
            this._broadcast('app.content_change', 'home');
        },

        /**
         * Articles state handler.
         *
         * @param {Object} state The state parameter bag
         */
        _articlesState: function (state) {
            this._destroyContent();
            this._content = this._link(new ArticlesController());
            this._content.delegateState(state);

            this._broadcast('app.content_change', 'articles');
        },

        /**
         * Help state handler.
         *
         * @param {Object} state The state parameter bag
         */
        _helpState: function (state) {
            this._destroyContent();
            this._content = this._link(new HelpController());
            this._content.delegateState(state);

            this._broadcast('app.content_change', 'help');
        },

        /**
         * About state handler.
         *
         * @param {Object} state The state parameter bag
         */
        _aboutState: function (state) {
            // If there is no content behind the panel we put the home
            // This is just in case the user enters via deeplinking
            if (!this._content) {
                this._homeState();
            }

            this._destroyPanel();
            this._panelView = this._link(new AboutView());
            this._panelView.appendTo(this._view.getElement());
            this._panelView.render();

            this._panelView.on('close', function () {
                var previousState = state.$info.previousState;

                // Switch to previous state
                if (previousState) {
                    this.setState('/' + previousState.getFullName(), previousState.getParams());
                } else {
                    this.setState('home');
                }
            }.bind(this));

            this._broadcast('app.content_change', 'about');
        },

        /**
         * Destroys the current content if any.
         */
        _destroyContent: function () {
            if (this._content) {
                this._content.destroy();
                this._content = null;
            }

            this._destroyPanel();
        },

        /**
         * Destroys the current panel if any.
         */
        _destroyPanel: function () {
            if (this._panelView) {
                this._panelView.destroy();
                this._panelView = null;
            }
        }
    });
});
