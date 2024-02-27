import { Controller } from "@hotwired/stimulus"
import { get } from "@rails/request.js"

// Connects to data-controller="group-plan"
export default class extends Controller {
  static targets = ["lppi", "gyrt", "sii", "planSelect"]


  toggleTargets(event) {

    let plan_id = event.target.value

    console.log(plan_id)
    if (plan_id == "2") { // for LPPI 
      this.lppiTarget.hidden = false
      this.gyrtTarget.hidden = true
      this.siiTarget.hidden = true
    } else if (plan_id == "8") { // for SII
      this.siiTarget.hidden = false
      this.lppiTarget.hidden = true
      this.gyrtTarget.hidden = true
    } else {
      this.siiTarget.hidden = true
      this.lppiTarget.hidden = true
      this.gyrtTarget.hidden = false
    }
  }

  search_plans(event) {
    let coop_id = event.target.selectedOptions[0].value
    let target = this.planSelectTarget.id

    get(`/cooperatives/${coop_id}/get_plan?target=${target}`, {
      responseKind: "turbo-stream"
    })

  }
}
