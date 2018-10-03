/* eslint-env node */

module.exports = function(environment) {
  var ENV = {
    modulePrefix: 'pompa',
    environment: environment,
    locationType: 'auto',
    EmberENV: {
      FEATURES: {
        // Here you can enable experimental features on an ember canary build
        // e.g. 'with-controller': true
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
    ENV.rootURL = "/";

    ENV.APP.apiHost = ""
    ENV.APP.apiNamespace = "api"
  }

  if (environment === 'staging') {
    ENV.rootURL = "/";

    ENV.APP.apiHost = ""
    ENV.APP.apiNamespace = "api"
  }

  if (environment === 'production') {
    ENV.rootURL = "/";

    ENV.APP.apiHost = ""
    ENV.APP.apiNamespace = "api"
  }

  if (environment === 'test') {
    // Testem prefers this...
    ENV.locationType = 'none';

    // keep test console output quieter
    ENV.APP.LOG_ACTIVE_GENERATION = false;
    ENV.APP.LOG_VIEW_LOOKUPS = false;

    ENV.APP.rootElement = '#ember-testing';
  }

  return ENV;
};
