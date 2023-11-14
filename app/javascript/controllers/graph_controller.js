import { Controller } from "@hotwired/stimulus"
import { get } from "@rails/request.js"
// import { ChartKick } from "ChartKick"

export default class extends Controller {
  static targets = ["typeSelect"]

  selectType(e) {
    let type_id = e.target.value;

    var chart = Chartkick.charts["coops-chart"]

    console.log(chart)

    get(`/update_charts?data_type=${type_id}`, {
      responseKind: "turbo-stream"
    })

    // get(`/coop_members/${member_id}/find_member?group_remit_id=${gr_id}`, {
    //   responseKind: "turbo-stream"
    // })
  }

}