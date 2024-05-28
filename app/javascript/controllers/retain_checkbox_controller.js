import { Controller } from "@hotwired/stimulus"

// Connects to data-controller="retain-checkbox"
export default class extends Controller {
  // connect() {
  //   this.element.addEventListener("change", this.handleChange.bind(this))
  // }
  // handleChange(event) {
  //   alert(`The checkbox with the ID '${event.target.id}' changed`);
  // }
  connect() {
    console.log("Connecting to data-controller retain-checkbox");
    this.loadCheckboxStates();
  }

  saveCheckboxState(event) {
    const checkbox = event.target;
    localStorage.setItem(checkbox.id, checkbox.value);
  }

  loadCheckboxStates(event) {
    const checkboxes = this.element.querySelectorAll('input[type="checkbox"]');
    checkboxes.forEach((checkbox) => {
      const savedState = localStorage.getItem(checkbox.id);
      if (savedState !== null) {
        checkbox.checked = savedState === 'true';
      }
      checkbox.addEventListener('change', this.saveCheckboxState.bind(this));
    });
  }
}
