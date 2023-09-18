import { Controller } from "@hotwired/stimulus"

export default class extends Controller {
  static targets = [ "button", "file" ]

  connect() {
    console.log("hello payment uplaoder here");
  }

  submit(e) {
    const btn = this.buttonTarget;
    const form = btn.closest("form");
    const file = this.fileTarget;

    form.submit();
    btn.value = "Uploading...";
    file.disabled = true;
    btn.disabled = true;

  }
}