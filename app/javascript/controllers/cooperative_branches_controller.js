import { Controller } from "@hotwired/stimulus"

// Connects to data-controller="cooperative-branches"
export default class extends Controller {
  static targets = ["select"]

  connect() {
    this.loadBranches()
  }

  loadBranches() {
    fetch("/countries")
      .then(response => response.json())
      .then(data => {
        this.selectTarget.innerHTML = data.map(country => {
          return `<option value="${country.id}">${country.name}</option>`;
        }).join("");
      });
  }
}
