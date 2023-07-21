
class PsheetPdf < Prawn::Document
  
  def initialize(pro_cov, view)
    super(
      page_size: "A4",
      page_layout: :portrait
    )
    @pro_cov = pro_cov
    @view = view

    define_grid(columns: 24, rows: 12, gutter: 10)

    letterhead
    title_block
    # count_table
  end


  def letterhead
    image Rails.root.join("app/assets/images/cis_logo.png"), width: 65
    font_size(12) { text "1 COOPERATIVE INSURANCE SYSTEM OF THE PHILIPPINES (1CISP)", style: :bold, leading: 2 }
    font_size(12) { text "Life and General Insurance", style: :bold, leading: 2 }
    font_size(7.5) { text "11 Mapagbigay corner Maunlad St., Brgy. Pinyahan, 1100 Quezon City", inline_format: true }
    move_down 20
  end

  def title_block
    font_size(14) { text "PROCESSING SHEET", style: :bold, align: :center }
    move_down 20
  end

  # def count_table
  #   table_data = [
  #     ["Count", "Amount of Coverage", "Effectivity", "Expiry", "Premium Due"],
  #     [@pro_cov.group_remit.batches.count, 0, @pro_cov.effectivity, @pro_cov.expiry, @pro_cov.group_remit.batches.sum(:premium)]
  #   ]
  #   table table_data
  # end

end