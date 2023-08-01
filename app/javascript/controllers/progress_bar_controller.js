import { Controller } from "@hotwired/stimulus"

// Connects to data-controller="progress-bar"
export default class extends Controller {
  static values = {
    url: String, // The URL to fetch the progress data from the server
  };
  static targets = ["progressBar", "button", "file"];

  intervalId = null

  updateProgress(e) {
    const btn = this.buttonTarget;
    const form = btn.closest("form");
    const file = this.fileTarget;

    form.submit();
    btn.value = "Uploading...";
    file.disabled = true;
    btn.disabled = true;

    this.intervalId = setInterval(() => {

      fetch(this.urlValue)
        .then(response => response.json())
        .then(data => {
          const progress = data.progress;
          this.updateProgressBar(progress);
        });


    }, 1000);
  }

  updateProgressBar(progress) {
    const progressBar = this.progressBarTarget;
    
    progressBar.style.width = `${progress}%`;
    progressBar.innerText = `${progress}%`;

    if (progress >= 100) {
      progressBar.classList.add("progress-bar-done");
      progressBar.innerText = "Done";
      this.stopUpdatingProgress()
    }
  }

  stopUpdatingProgress() {
    clearInterval(this.intervalId); // Clear the interval using the stored interval ID
  }

}

