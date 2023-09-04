import { Controller } from "@hotwired/stimulus"
import { get } from "@rails/request.js"

// Connects to data-controller="geography"
export default class extends Controller {
  static targets = ["provinceSelect", "muniSelect", "brgySelect"]


  search_provinces(event) {
    let region_id = event.target.selectedOptions[0].value
    let target = this.provinceSelectTarget.id

    this.muniSelectTarget.hidden = true
    this.brgySelectTarget.hidden = true

    get(`/geo_regions/${region_id}/selected?target=${target}`, {
      responseKind: "turbo-stream"
    })
  }

  search_municipalities(event) {
    let province_id = event.target.selectedOptions[0].value
    let target = this.muniSelectTarget.id

    this.muniSelectTarget.hidden = false
    this.brgySelectTarget.hidden = true

    get(`/geo_provinces/${province_id}/selected?target=${target}`, {
      responseKind: "turbo-stream"
    })
  }

  search_barangays(event) {
    let muni_id = event.target.selectedOptions[0].value
    let target = this.brgySelectTarget.id

    this.brgySelectTarget.hidden = false

    get(`/geo_municipalities/${muni_id}/selected?target=${target}`, {
      responseKind: "turbo-stream"
    })
  }
}
