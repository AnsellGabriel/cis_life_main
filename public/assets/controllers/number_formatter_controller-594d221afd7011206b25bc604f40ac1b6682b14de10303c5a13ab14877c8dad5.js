// app/javascript/controllers/number_format_controller.js
import { Controller } from '@hotwired/stimulus';

export default class extends Controller {
  static targets = ['input'];

  connect() {
    this.formatNumber();
  }

  formatNumber() {
    this.inputTarget.addEventListener('input', () => {
      // Remove non-numeric characters
      let numericValue = this.inputTarget.value.replace(/\D/g, '');

      // Format the number with commas
      let formattedValue = Number(numericValue).toLocaleString();

      // Update the input field with the formatted number
      this.inputTarget.value = formattedValue;
    });
  }
};
