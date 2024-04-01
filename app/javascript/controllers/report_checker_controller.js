import { Controller } from "@hotwired/stimulus";
import { get } from "@rails/request.js";

export default class extends Controller {
  connect() {
    console.log('Report Checker Controller connected...')
    if (localStorage.getItem("downloadTitle") && localStorage.getItem("downloadLink")) {
      this.showDownload();
    }
  }

  check() {
    const check_report_status = setInterval(function () {
      const downloaderToast = document.getElementById("downloader");

      if (downloaderToast.classList.contains("d-none")) {
        get("/treasury/accounts/show_report", {
          responseKind: "turbo-stream",
        });
        console.log('Checking report status...')
      } else {
        clearInterval(check_report_status);
        console.log('Report is ready to download!')
        // initialize bs toast
        let toastEl = document.getElementById("downloaderToast");
        let toastTitle = document.getElementById("downloadTitle");
        let toastLink = document.getElementById("downloadLink");
        let toast = new bootstrap.Toast(toastEl);
        
        toast.show();
        // set local storage
        localStorage.setItem("downloadTitle", toastTitle.textContent);
        localStorage.setItem("downloadLink", toastLink.href);
      }
    }, 3000);
  }

  showDownload() {
    let toastContainer = document.getElementById("downloader");
    let toastEl = document.getElementById("downloaderToast");
    let toastTitle = document.getElementById("downloadTitle");
    let toastLink = document.getElementById("downloadLink");
    let toast = new bootstrap.Toast(toastEl);

    toastContainer.classList.remove("d-none");
    toastTitle.textContent = localStorage.getItem("downloadTitle");
    toastLink.href = localStorage.getItem("downloadLink");
    toast.show();
    // set local storage
  } 

  clearDownload() {
    localStorage.removeItem("downloadTitle");
    localStorage.removeItem("downloadLink");
  }
}
