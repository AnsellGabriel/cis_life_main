import { Controller } from "@hotwired/stimulus"
import { get } from "@rails/request.js"
// Connects to data-controller="agreements"
export default class extends Controller {
  // connect() {
  // }
  static targets = [ "agreementSelect" ]

  search_agreement(event) {
    let agreement_benefit_id  = event.target.selectedOptions[0].value
    let target = this.agreementSelectTarget.id

    get(`/agreement_benefits/${agreement_benefit_id}/selected?target=${target}`, {
        responseKind: "turbo-stream" 
    })
    }
};
