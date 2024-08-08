import { Controller } from "@hotwired/stimulus"
// import { elements } from "trix"

// Connects to data-controller="hider"
export default class extends Controller {
  static targets = ["input", "hideme", "plan", "amounts", "vat", "vatContainer", "discount", "discountContainer", "welcomeDiv"]
  connect() {
    if (this.hasWelcomeDivTarget) {
      setTimeout(() => {
        this.hideDiv()
      }, 5000)
    } else {
      this.toggle()
      this.toggleVat()
    }

  }

  toggle() {
    if (this.hasPlanTarget && this.hasInputTarget) {
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
  }

  toggleVat() {
    if (this.vatTarget.checked) {
      this.vatContainerTarget.classList.remove("hidden");
    } else {
      this.vatContainerTarget.classList.add("hidden");
    }
  }

  hideDiv() {
    console.log("connected to hideDiv")
    this.welcomeDivTarget.style.display = "none";
  }
}
