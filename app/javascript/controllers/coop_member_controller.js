import { Controller } from "@hotwired/stimulus"

export default class extends Controller {
  static targets = ["memberSelect"]

  selectMember(e) {
    let id = e.target.value;

    // console.log(id)

  //   fetch(`/coop_members/${id}/find_member`)
  //   .then((response) => response.json())
  //   .then((data) => console.log(data));
   }

   doSomethingWithYourDataHere(data) {
    // console.log(data)
   }
}