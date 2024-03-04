import { Controller } from "@hotwired/stimulus"
import { get } from "@rails/request.js"

// Connects to data-controller="benefit"
export default class extends Controller {
  static targets = ["benSelect", "prem"]
  connect() {
    console.log("connected")
    let ben_id = this.benSelectTarget.selectedOptions[0].value

    if (ben_id == "1") { // for Life Benefit 
      this.premTarget.hidden = false
    } else {
      this.premTarget.hidden = true
    }

  }

  toggleTargets2(event) {
    let ben_id = event.target.value;

    if (ben_id == "1") { // for Life Benefit 
      this.premTarget.hidden = false
    } else {
      this.premTarget.hidden = true
    }
  }

}