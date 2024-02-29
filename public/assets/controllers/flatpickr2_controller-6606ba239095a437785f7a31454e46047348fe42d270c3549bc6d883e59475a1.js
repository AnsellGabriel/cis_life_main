import { Controller } from "@hotwired/stimulus"
import flatpickr from "flatpickr";

// Connects to data-controller="flatpickr2"
export default class extends Controller {
  connect() {
    console.log("Connected", this.element)

    const startInput = flatpickr(".start_time", {
      onChange: function (selectedDates, dateStr, instance) {
        // console.log(dateStr)
        endInput.set("minDate", dateStr)
      }
    })
    const endInput = flatpickr(".end_time")



  }
};
