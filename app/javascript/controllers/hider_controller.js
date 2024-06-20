import { Controller } from "@hotwired/stimulus"
// import { elements } from "trix"

// Connects to data-controller="hider"
export default class extends Controller {
  static targets = ["input", "hideme", "plan"]
  connect() {
    this.toggle()
  }

  toggle() {
    if (this.planTarget.value !== '') {
      this.hidemeTarget.style.display = "block";
      this.inputTarget.checked = true;
    } else if (this.inputTarget.checked) {
      this.hidemeTarget.style.display = "block";
    } else {
      this.hidemeTarget.style.display = "none";
    }
  }
}
