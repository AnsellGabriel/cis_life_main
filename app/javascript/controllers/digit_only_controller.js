import { Controller } from '@hotwired/stimulus';

export default class extends Controller {
  static targets = ['input'];

  connect() {
    this.formatNumber();
  }

  formatNumber() {
    this.inputTarget.addEventListener("input", () => {
      // Get the current input value
      const inputValue = this.inputTarget.value;
      
      // Remove any non-digit characters
      const digitsOnly = inputValue.replace(/\D/g, "");

      this.inputTarget.value = digitsOnly;
    });
  }
}
