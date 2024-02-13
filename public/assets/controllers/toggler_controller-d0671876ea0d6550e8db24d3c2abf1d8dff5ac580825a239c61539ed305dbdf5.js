import { Controller } from "@hotwired/stimulus"

// Connects to data-controller="toggler"
export default class extends Controller {
  static targets = ["toggleable"]

  toggle(event) {
    event.preventDefault()

    const btn = event.currentTarget
    const buttonId = btn.dataset.id

    this.toggleableTargets.forEach(element => {

      if (buttonId === element.dataset.id) {
        element.classList.toggle("hidden")
      } else {
        element.classList.add("hidden")
      }

    })
  }

  toggleRadio(event) {
    const btn = event.currentTarget;
    const buttonId = btn.dataset.id;
  
    this.toggleableTargets.forEach(element => {
      const inputs = element.querySelectorAll("input");
      const isTargetElement = buttonId === element.dataset.id;
  
      element.classList.toggle("hidden", !isTargetElement);
      inputs.forEach(input => {
        input.disabled = !isTargetElement;
      });
    });
  }
  
}
;
