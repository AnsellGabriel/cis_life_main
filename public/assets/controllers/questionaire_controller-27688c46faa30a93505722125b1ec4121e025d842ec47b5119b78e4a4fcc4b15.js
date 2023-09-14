import { Controller } from "@hotwired/stimulus"

export default class extends Controller {
    static targets = [ "answer", "container", "input", "submit" ]

  connect() {
    this.showContainer()
    // this.validateForm();
  }

  showContainer() {  
    if (this.answerTarget.checked) {
      this.containerTarget.classList.remove('d-none')
    } else if (this.answerTarget.checked && this.inputTarget.value != "") {
      this.containerTarget.classList.remove('d-none')
    } else {
      this.containerTarget.classList.add('d-none')
      this.inputTarget.value = ""
    }
  }

    // validateForm() {
    //   // Disable the submit button initially
    //   console.log(this.submitTarget)
    //   const submitButton = this.submitTarget;
    //   submitButton.disabled = true;

    //   // Add event listeners to each input and answer target
    //   this.inputTargets.forEach((input) => {
    //     input.addEventListener('input', this.checkFormValidity.bind(this));
    //   });

    //   this.answerTargets.forEach((answer) => {
    //     answer.addEventListener('change', this.checkFormValidity.bind(this));
    //   });
    // }

    // checkFormValidity() {
    //   // Enable the submit button if all fields are answered
    //   const submitButton = document.querySelector('input[type="submit"]');
    //   const allInputsFilled = this.inputTargets.every((input) => input.value !== '');
    //   const allAnswersChecked = this.answerTargets.some((answer) => answer.checked);

    //   submitButton.disabled = !(allInputsFilled && allAnswersChecked);
    // }
};
