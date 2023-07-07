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
    event.preventDefault()

    const btn = event.currentTarget
    const radios = document.querySelectorAll('input[type="radio"]');
    const buttonId = btn.dataset.id
    
    this.toggleableTargets.forEach(element => {

      if (buttonId === element.dataset.id) {
        element.classList.remove("hidden")
      } else {
        element.classList.add("hidden")
      }

    })
    
    radios.forEach((r) => {
      if (r.checked)
       r.classList.add("claims-btn")
      else
        r.classList.remove("claims-btn")
    })
  }
}

