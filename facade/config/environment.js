'use strict';

module.exports = function(environment) {
  let ENV = {
    modulePrefix: 'pompa',
    environment,
    rootURL: '/',
    locationType: 'auto',
    EmberENV: {
      FEATURES: {
        // Here you can enable experimental features on an ember canary build
        // e.g. EMBER_NATIVE_DECORATOR_SUPPORT: true
      },
      EXTEND_PROTOTYPES: {
        // Prevent Ember Data from overriding Date.parse.
        Date: false
      }
    },

    APP: {
      // Here you can pass flags/options to your application instance
      // when it is created
    },
  };

  if (environment === 'development') {
    ENV.APP.apiHost = ""
    ENV.APP.apiNamespace = "api"
    ENV.APP.campaignChallenge = "yes";
  }

  if (environment === 'staging') {
    ENV.APP.apiHost = ""
    ENV.APP.apiNamespace = "api"
    ENV.APP.campaignChallenge = "yes";
  }

  if (environment === 'production') {
    ENV.APP.apiHost = ""
    ENV.APP.apiNamespace = "api"
    ENV.APP.campaignChallenge = "yes";
  }

  if (environment === 'test') {
    // Testem prefers this...
    ENV.locationType = 'none';

    // keep test console output quieter
    ENV.APP.LOG_ACTIVE_GENERATION = false;
    ENV.APP.LOG_VIEW_LOOKUPS = false;

    ENV.APP.rootElement = '#ember-testing';
    ENV.APP.autoboot = false;
  }

  return ENV;
};