import { Controller } from "@hotwired/stimulus"
// import { elements } from "trix"

// Connects to data-controller="hider"
export default class extends Controller {
  static targets = ["input", "hideme", "plan", "amounts", "vat", "vatContainer", "discount", "discountContainer"]
  connect() {
    this.toggle()
    this.toggleVat()
  }

  toggle() {
    if (this.planTarget.value !== '') {
      this.hidemeTarget.style.display = "flex";
      this.amountsTarget.classList.remove("hidden");
      this.inputTarget.checked = true;
    } else if (this.inputTarget.checked) {
      this.hidemeTarget.style.display = "flex";
      this.amountsTarget.classList.remove("hidden");
    } else {
      this.hidemeTarget.style.display = "none";
      this.amountsTarget.classList.add("hidden");
    }
  }

  toggleVat() {
    if (this.vatTarget.checked) {
      this.vatContainerTarget.classList.remove("hidden");
    } else {
      this.vatContainerTarget.classList.add("hidden");
    }
  }
}
