import { Controller } from "@hotwired/stimulus"
import { get } from "@rails/request.js"


export default class extends Controller {
    static targets = [ "typeSelect", "life", "others" ]

    connect() {
        let type_id = this.typeSelectTarget.selectedOptions[0].value

        if (type_id == 1) { // for life benefit
            this.othersTarget.hidden = true
            this.lifeTarget.hidden = false
        }
        else {
            this.othersTarget.hidden = false
            this.lifeTarget.hidden = true
        }
    }

    toggleTargets(event) {
        let type_id = event.target.value

        if (type_id == 1) { // for life benefit
            this.othersTarget.hidden = true
            this.lifeTarget.hidden = false
        }
        else {
            this.othersTarget.hidden = false
            this.lifeTarget.hidden = true
        }
    }
}