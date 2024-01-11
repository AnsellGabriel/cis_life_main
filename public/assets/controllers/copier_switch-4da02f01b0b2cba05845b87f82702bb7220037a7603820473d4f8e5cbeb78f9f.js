import { Controller } from "@hotwired/stimulus"

export default class extends Controller {
  static targets = ["source", "destination"]
  
  connect() {
    console.log('CopierSwitch connected')
  }

  copy() {
    console.log('CopierSwitch connected')
  }
}
;
