import { Controller } from "@hotwired/stimulus"
import { get } from "@rails/request.js"

// Connects to data-controller="group-plan"
export default class extends Controller {
  static targets = ["lppi", "gyrt"]


  toggleTargets(event) {

    let plan_id = event.target.value

    console.log(plan_id)
    if (plan_id == "2") {
      this.lppiTarget.hidden = false
      this.gyrtTarget.hidden = true
    } else {
      this.lppiTarget.hidden = true
      this.gyrtTarget.hidden = false
    }
  }
}
