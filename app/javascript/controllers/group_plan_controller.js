import { Controller } from "@hotwired/stimulus"
import { get } from "@rails/request.js"

// Connects to data-controller="group-plan"
export default class extends Controller {
  static targets = ["unitSelect", "benefitTable"]



  search_units(event) {
    console.log("Connected sa group-plan");
    let plan_id = event.target.selectedOptions[0].value
    let target = this.unitSelectTarget.id

    get(`/plans/${plan_id}/selected?target=${target}`, {
      responseKind: "turbo-stream"
    })
  }

  selectUnits(event) {
    let unit_id = event.target.value;


    get(`/plan_units/${unit_id}/find_units`, {
      responseKind: "turbo-stream"
    })
  }
}
