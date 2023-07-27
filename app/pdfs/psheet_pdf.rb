
class PsheetPdf < Prawn::Document
  
  def initialize(pro_cov, total_life_cov, view)
    super(
      page_size: "A4",
      page_layout: :portrait
    )
    @pro_cov = pro_cov
    @total_life_cov = total_life_cov
    @view = view

    self.font_families.update("Roboto" => {
      :normal => Rails.root.join("app/assets/fonts/Roboto/Roboto-Regular.ttf"),
      :italic => Rails.root.join("app/assets/fonts/Roboto/Roboto-Italic.ttf"),
      :bold => Rails.root.join("app/assets/fonts/Roboto/Roboto-Bold.ttf"),
      :bold_italic => Rails.root.join("app/assets/fonts/Roboto/Roboto-BoldItalic.ttf")
      })

    font "Roboto", size: 9

    define_grid(columns: 24, rows: 12, gutter: 10)

    letterhead
    title_block
    upper_part
    count_table
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

  def upper_part
    font_size(10) { text "Group Remit ID <b>#{@pro_cov.id}</b>", inline_format: true}
    move_down 5
    font_size(10) { text "Group Remit Date <b>#{@pro_cov.created_at.strftime('%B %d, %Y')}</b>", inline_format: true}
    move_down 10

    font_size(10) { text "Cooperative <b><u>#{@pro_cov.group_remit.agreement.cooperative}</u></b>", inline_format: true}
    move_down 20
  end

  def count_table
    table_data = [
      ["Count", "Amount of Coverage", "Effectivity", "Expiry", "Premium Due"],
      [@pro_cov.group_remit.batches.count, @view.to_currency(@total_life_cov), @pro_cov.effectivity, @pro_cov.expiry, @view.to_currency(@pro_cov.group_remit.batches.sum(:premium))]
    ]
    table table_data
  end

end