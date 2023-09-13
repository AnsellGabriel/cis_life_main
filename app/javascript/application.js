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
  // initialize bs tooltip
  var tooltipTriggerList = [].slice.call(
    document.querySelectorAll('[data-bs-toggle="tooltip"]')
  );
  var tooltipList = tooltipTriggerList.map(function (tooltipTriggerEl) {
    return new bootstrap.Tooltip(tooltipTriggerEl);
  });

  // initialize bs toast
  var toastElList = [].slice.call(document.querySelectorAll('.toast'))
  var toastList = toastElList.map(function (toastEl) {
    return new bootstrap.Toast(toastEl, option)
  })
});