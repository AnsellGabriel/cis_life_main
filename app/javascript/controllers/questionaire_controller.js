import { Controller } from "@hotwired/stimulus"

export default class extends Controller {
    static targets = [ "answer", "container" ]

  showContainer() {  
    if (this.answerTarget.checked) {
      this.containerTarget.classList.remove('d-none')
    } else {
      this.containerTarget.classList.add('d-none')
    }
  }
}