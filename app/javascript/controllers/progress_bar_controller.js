import { Controller } from "@hotwired/stimulus"

// Connects to data-controller="progress-bar"
export default class extends Controller {
  static targets = ["progress"]

  connect() {
    let progressBar = this.progressTarget

    let progress = setInterval(() => {
      this.update(progressBar)
      if (progressBar.getAttribute("aria-valuenow") >= 100) {
        clearInterval(progress)
      }
    }, 1000)
    
    progress
  }

  update(progressBar) {
    progressBar.setAttribute("aria-valuenow", Number(progressBar.getAttribute("aria-valuenow")) + 10)
    progressBar.style.width = progressBar.getAttribute("aria-valuenow") + "%"
    progressBar.innerHTML = progressBar.getAttribute("aria-valuenow") + "%"
    console.log(progressBar.getAttribute("aria-valuenow"))
  }

  
}

