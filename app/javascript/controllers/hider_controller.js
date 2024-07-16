import { Controller } from "@hotwired/stimulus"
// import { elements } from "trix"

// Connects to data-controller="hider"
export default class extends Controller {
  static targets = ["input", "hideme", "plan", "amounts", "vat", "vatContainer"]
  connect() {
    this.toggle()
  }

  toggle() {
    if (this.planTarget.value !== '') {
      this.hidemeTarget.style.display = "block";
      this.amountsTarget.classList.remove("hidden");
      this.inputTarget.checked = true;
    } else if (this.inputTarget.checked) {
      this.hidemeTarget.style.display = "block";
      this.amountsTarget.classList.remove("hidden");
    } else {
      this.hidemeTarget.style.display = "none";
      this.amountsTarget.classList.add("hidden");
    }

    if 
  }
}
