import { Controller } from "@hotwired/stimulus"
// import { elements } from "trix"

// Connects to data-controller="hider"
export default class extends Controller {
  static targets = ["input", "hideme"]
  connect() {
    console.log("Connected to hider")
    this.toggle()
  }

  toggle() {
    if (this.inputTarget.checked) {
      this.hidemeTarget.style.display = "block";
    } else {
      this.hidemeTarget.style.display = "none";
    }
  }
}
