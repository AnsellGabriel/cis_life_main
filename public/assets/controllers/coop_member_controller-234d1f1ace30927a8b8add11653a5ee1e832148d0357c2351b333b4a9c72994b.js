import { Controller } from "@hotwired/stimulus"
import { get } from "@rails/request.js"

export default class extends Controller {
  static targets = ["memberSelect", "groupRemit"]

  selectMember(e) {
    let member_id = e.target.value;
    let gr_id = this.groupRemitTarget.value; 
    

    get(`/coop_members/${member_id}/find_member?group_remit_id=${gr_id}`, {
      responseKind: "turbo-stream"
    })
  }
};
