import { Controller } from "@hotwired/stimulus"
import Datatable from "./datatable_controller";

// Connects to data-controller="encoded-ors-datatable"
export default class extends Datatable {
  get columns() {
    return [
      // { data: 'id', visible: false },
      { data: 'id' },
      { data: 'or_no' },
      { data: 'or_date' },
      { data: 'coop' },
      { data: 'batches_count' },
      { data: 'plan' },
    ]
  }
}
