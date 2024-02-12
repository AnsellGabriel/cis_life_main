import { Controller } from "@hotwired/stimulus"
import { get } from "@rails/request.js"


export default class extends Controller {
  static targets = ['members']

  showMembers(event) {
    const coopId = event.target.value
    
    get(`/mis/members/update_table?cooperative=${coopId}`, {
      responseKind: "turbo-stream"
  })
  }
}
;
