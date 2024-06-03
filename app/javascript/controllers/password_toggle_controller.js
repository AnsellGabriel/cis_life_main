import { Controller } from "@hotwired/stimulus"

export default class extends Controller {
  static targets = [ "input", "icon" ] 

  password() {
    let password_field = this.inputTarget;
    let icon = this.iconTarget;

    if (password_field.type === "password") {
      icon.classList.remove('bi-eye-slash');
      icon.classList.add('bi-eye');
      password_field.type = "text";
    } else {
      icon.classList.remove('bi-eye');
      icon.classList.add('bi-eye-slash');
      password_field.type = "password";
    }
  }
}