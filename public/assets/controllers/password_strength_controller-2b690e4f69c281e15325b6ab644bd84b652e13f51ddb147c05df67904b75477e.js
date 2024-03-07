import { Controller } from "@hotwired/stimulus"

export default class extends Controller {
  static targets = ["min_char", "lowercase", "uppercase", "digit", "special", "btn"]

  change(event) {
    const string = event.currentTarget.value;
    // target = li element in the list, validator = function to validate the string
    const validationTargets = [
      { target: this.min_charTarget, validator: string.length >= 8 },
      { target: this.lowercaseTarget, validator: this.hasLowerCaseLetter(string) },
      { target: this.uppercaseTarget, validator: this.hasUpperCaseLetter(string) },
      { target: this.digitTarget, validator: this.hasDigit(string) },
      { target: this.specialTarget, validator: this.hasSpecialChar(string) }
    ];

    // toggle css class for each li element
    validationTargets.forEach(({ target, validator }) => {
      this.toggleValidationClass(target, validator);
    });

    // enable/disable submit button
    const isAllValid = validationTargets.every(({ validator }) => validator);
    this.btnTarget.disabled = !isAllValid;
  }

  // toggle css class for li element
  toggleValidationClass(target, isValid) {
    const cssClass = isValid ? "text-success" : "text-danger";
    target.classList.remove(isValid ? "text-danger" : "text-success");
    target.classList.add(cssClass);
  }

  // regex to check if string has lowercase, uppercase, digit, special character
  hasLowerCaseLetter(str) { return /[a-z]/.test(str); }
  hasUpperCaseLetter(str) { return /[A-Z]/.test(str); }
  hasDigit(str) { return /\d/.test(str); }
  hasSpecialChar(str) { return /[^a-zA-Z0-9]/.test(str); }
};
