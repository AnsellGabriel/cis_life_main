import { Controller } from "@hotwired/stimulus"

export default class extends Controller {
    static targets = [ "answer", "container", "input" ]

  connect() {
    this.showContainer()
  }

  showContainer() {  
    console.log(this.inputTarget.value)
    if (this.answerTarget.checked) {
      this.containerTarget.classList.remove('d-none')
    } else if (this.answerTarget.checked && this.inputTarget.value != "") {
      this.containerTarget.classList.remove('d-none')
    } else {
      this.containerTarget.classList.add('d-none')
      this.inputTarget.value = ""
    }
  }
}