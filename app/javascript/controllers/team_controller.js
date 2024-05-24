import { Controller } from "@hotwired/stimulus"
import { get } from "@rails/request.js"


// Connects to data-controller="team"
export default class extends Controller {
  static targets = ["employeeSelect"]

  connect() {
    this.employeeSelectTarget.hidden = true
    console.log("Connecting to data-controller=team")
  }

  search_employee(event) {
    let team_id = event.target.selectedOptions[0].value
    let target = this.employeeSelectTarget.id

    get(`/teams/${team_id}/selected?target=${target}`, {
      responseKind: "turbo-stream"
    })
    this.employeeSelectTarget.hidden = false
  }
}
