import { Controller } from "@hotwired/stimulus"
import { get } from "@rails/request.js"

export default class extends Controller {
  static targets = ["memberSelect"]

  selectMember(e) {
    let id = e.target.value;

    get(`/coop_members/${id}/find_member`, {
      responseKind: "turbo-stream"
    })
  }
}