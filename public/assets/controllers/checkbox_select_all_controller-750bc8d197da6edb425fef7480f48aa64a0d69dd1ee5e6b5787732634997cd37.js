import { Controller } from "@hotwired/stimulus"

// Connects to data-controller="checkbox-select-all"
export default class extends Controller {
  static targets = ["parent", "child"]
  connect() {
    this.parentTarget.checked = false
    this.childTargets.map(x => x.checked = false)

    // this.loadCheckedStateFromLocalStorage()    
  }
  
  toggleChildren(){
    const label = this.element.querySelector('label[for="' + this.parentTarget.id + '"]')

    if (this.parentTarget.checked) {
      this.childTargets.map(x => x.checked = true)
      label.innerText = 'Unselect All';
    } else {
      this.childTargets.map(x => x.checked = false) 
      label.innerText = 'Select All';
    }

  }

  toggleParent(){
    if (this.childTargets.map(x => x.checked).includes(false)) {
      this.parentTarget.checked = false
    } else {
      this.parentTarget.checked = true
    }

    // console.log("save item to local storage")
    // this.childTargets.forEach((checkbox, index) => {
    //   localStorage.setItem(`checkbox${index + 1}`, checkbox.checked)

    // })

  }

  // save() {
  //   console.log("save item to local storage")
  //   this.childTargets.forEach((checkbox, index) => {
  //     localStorage.setItem(`checkbox${index + 1}`, checkbox.checked)

  //   })
  // }

  // loadCheckedStateFromLocalStorage() {
  //   console.log("load check state from storage")
  //   this.childTargets.forEach((checkbox, index) => {
  //     const checked = JSON.parse(localStorage.getItem(`checkbox${index +1}`))
  //     if (checked !== null) {
  //       checkbox.checked = checked
  //     }
  //   })
  // }

};
