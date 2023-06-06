import { Controller } from "@hotwired/stimulus"

// Connects to data-controller="toggler"
export default class extends Controller {
  static targets = ["toggleable"]

  toggle() {
    this.toggleableTargets.forEach(element => {
      element.classList.toggle("hidden")
    })
  }
}
