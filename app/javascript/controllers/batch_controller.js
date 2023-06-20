import { Controller } from "@hotwired/stimulus"
import { get } from "@rails/request.js"

export default class extends Controller {
    static targets = ["dependentSelect"]

    change(event) {
        let member_id = event.target.selectedOptions[0].value
        let target = this.dependentSelectTarget.id

        // console.log(member_id)
        // console.log(target)
        
        get(`/coop_members/${member_id}/selected?target=${target}`, {
            responseKind: "turbo-stream"
        })
    }
}

