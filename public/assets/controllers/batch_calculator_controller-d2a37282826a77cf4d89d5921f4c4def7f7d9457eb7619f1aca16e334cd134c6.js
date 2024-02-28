import { Controller } from "@hotwired/stimulus"
import { get } from "@rails/request.js"

export default class extends Controller {
    static target = ["container"]
    
    change(event) {
        let benefit_id = event.target.selectedOptions[0].value

        // console.log(member_id)
        // console.log(target)
        
        get(`/agreement_benefits/${benefit_id}/selected`, {
            responseKind: "turbo-stream"
        })
    }
}
;
