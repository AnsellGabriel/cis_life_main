import "jquery"
import $ from 'jquery';
import { Turbo } from "@hotwired/turbo-rails"
import "@popperjs/core"
import 'bootstrap';
import "controllers"
import * as bootstrap from "bootstrap"
import "@hotwired/turbo-rails"
import "controllers"
// import "bootstrap"
import "@nathanvda/cocoon"
// import 'cocoon-js'

Turbo.session.drive = true
window.bootstrap = bootstrap

document.addEventListener("turbo:load", function () {
  // This code is copied from Bootstrap's docs. See link below.
  var tooltipTriggerList = [].slice.call(
    document.querySelectorAll('[data-bs-toggle="tooltip"]')
  );
  var tooltipList = tooltipTriggerList.map(function (tooltipTriggerEl) {
    return new bootstrap.Tooltip(tooltipTriggerEl);
  });
});
