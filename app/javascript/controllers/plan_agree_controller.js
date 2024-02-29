import { Controller } from "@hotwired/stimulus"
import { get } from "@rails/request.js"

// Connects to data-controller="group-plan"
export default class extends Controller {
  static targets = ["lppi", "gyrt", "sii", "prem", "planSelect", "benSelect"]

  connect() {
    let ben_id = this.benSelectTarget.selectedOptions[0].value

    if (ben_id == "1") { // for Life Benefit 
      this.premTarget.hidden = false
    } else {
      this.premTarget.hidden = true
    }
  }

  toggleTargets(event) {

    let plan_id = event.target.value

    console.log(plan_id)
    if (plan_id == "2") { // for LPPI 
      this.lppiTarget.hidden = false
      this.gyrtTarget.hidden = true
      // this.siiTarget.hidden = true
    } else if (plan_id == "1" || plan_id == "3" || plan_id == "4") { // for GYRT
      // this.siiTarget.hidden = false
      this.lppiTarget.hidden = true
      this.gyrtTarget.hidden = false
    } else {
      // this.siiTarget.hidden = true
      this.lppiTarget.hidden = true
      this.gyrtTarget.hidden = true
    }
  }

  search_plans(event) {
    let coop_id = event.target.selectedOptions[0].value
    let target = this.planSelectTarget.id

    get(`/cooperatives/${coop_id}/get_plan?target=${target}`, {
      responseKind: "turbo-stream"
    })

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
