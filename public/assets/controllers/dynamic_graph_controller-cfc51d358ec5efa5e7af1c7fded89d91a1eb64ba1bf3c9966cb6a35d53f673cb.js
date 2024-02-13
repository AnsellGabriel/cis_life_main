import { Controller } from "@hotwired/stimulus"

// Connects to data-controller="dynamic-graph"
export default class extends Controller {
  connect() {
    console.log("connecting to dynamic-graph")
  }
};
