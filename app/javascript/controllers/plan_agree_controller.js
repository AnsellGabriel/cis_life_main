import { Controller } from "@hotwired/stimulus"
import { get } from "@rails/request.js"

export default class extends Controller {
  static targets = ["lppi", "gyrt", "prem", "planSelect", "benSelect"]

  connect() {
    // console.log("konek123")

    let plan_id = this.planSelectTarget.selectedOptions[0].value

    if (plan_id == "2") {
      this.lppiTarget.hidden = false
      this.gyrtTarget.hidden = true
    }
    else if (plan_id == "1" || plan_id == "3" || plan_id == "4") {
      this.lppiTarget.hidden = true
      this.gyrtTarget.hidden = false
    }

  }

  toggleTargets(event) {

    let plan_id = event.target.value

    // console.log(`id-${plan_id}`)
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
}
