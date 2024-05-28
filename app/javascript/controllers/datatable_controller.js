import { Controller } from "@hotwired/stimulus"

// Connects to data-controller="datatable"
export default class extends Controller {
  static targets = ['table']

  connect() {
    if (!$.fn.dataTable.isDataTable(this.tableTarget)) {
      this.dataTable = $(this.tableTarget).DataTable(this.dataTableOptions)
      $(this.tableTarget).on('init.dt', this.init.bind(this))
    }
  }

  disconnect() {
    if ($.fn.dataTable.isDataTable(this.tableTarget)) {
      // this.dataTable.destroy()
    }
    // this.element.remove()
  }
  manipulateData(data) {
    return data
  }

  get source() {
    return this.data.get('source')
  }

  get dataTableOptions() {
    return {
      // keys: !0,
      // responsive: true,
      // deferRender: true,
      // processing: true,
      serverSide: true,
      ajax: {
        url: this.source,  // it is the url that we give in view like this data-source="<%= root_path(format: :json) %>"
        data: this.manipulateData.bind(this)
      },
      // below are the option of the datatable
      pageLength: this.pageLength,
      order: this.order,
      searching: this.searching,
      columns: this.columns,
      language: { searchPlaceholder: this.searchPlaceholder }
    }
  }

  get pageLength() {
    return 10
  }

  // get order () {
  //   return false
  // }

  get order() {
    return [[0, 'asc']]
  }

  get searching() {
    return true
  }

  get columns() {
    return [
      // { data: 'first_name' },
      // { data: 'dt_action' }
    ]
  }

  get searchPlaceholder() {
    return 'Search...'
  }
}
