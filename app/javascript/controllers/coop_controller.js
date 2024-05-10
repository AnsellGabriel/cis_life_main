import { Controller } from "@hotwired/stimulus"
import { get } from "@rails/request.js"

export default class extends Controller {
    static targets = ["branchSelect", "agreementSelect"]
    connect() {
        console.log("connected")
    }

    change(event) {
        let coop_id = event.target.selectedOptions[0].value
        let target = this.branchSelectTarget.id

        get(`/cooperatives/${coop_id}/selected?target=${target}`, {
            responseKind: "turbo-stream"
        })
    }

    search_agreement(event) {
        let coop_id = event.target.selectedOptions[0].value
        let target = this.agreementSelectTarget.id

        var parts = coop_id.split('/')
        var final_id = parts[parts.length - 1]

        get(`/cooperatives/${final_id}/select_agreement?target=${target}`, {
            responseKind: "turbo-stream"
        })
    }
}

