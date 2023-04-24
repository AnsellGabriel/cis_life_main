import "jquery"
import $ from 'jquery';
import { Turbo } from "@hotwired/turbo-rails"
Turbo.session.drive = true

import "controllers"
import * as bootstrap from "bootstrap"
window.bootstrap = bootstrap

// Configure your import map in config/importmap.rb. Read more: https://github.com/rails/importmap-rails
import "@hotwired/turbo-rails"
import "controllers"
import "@popperjs/core"
import "bootstrap"

import 'cocoon-js';

$(document).ready(function() {
    console.log('jQuery is working!');
  });