/* eslint no-console:0 */
// This file is automatically compiled by Webpack, along with any other files
// present in this directory. You're encouraged to place your actual application logic in
// a relevant structure within app/javascript and only use these pack files to reference
// that code so it'll be compiled.
//
// To reference this file, add <%= javascript_pack_tag 'application' %> to the appropriate
// layout file, like app/views/layouts/application.html.erb

// Import CSS for bundling
// To reference styles, add <%= stylesheet_pack_tag 'application' %>to the appropriate
// layout file, like app/views/layouts/application.html.erb
import('styles/application.scss');

// Require static/global JS functions and config
require("global/i18n");
require("global/pause_all_videos");

// Load App context for ReactRails
const componentRequireContext = require.context("components", true);

const ReactRailsUJS = require("react_ujs");

ReactRailsUJS.useContext(componentRequireContext);
