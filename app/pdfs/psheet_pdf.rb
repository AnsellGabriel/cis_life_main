
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
    denied_table
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
    move_down 10

    font_size(10) { text "Group Remit Date <b>#{@pro_cov.created_at.strftime('%B %d, %Y')}</b>", inline_format: true}
    move_down 10

    font_size(10) { text "Cooperative <b><u>#{@pro_cov.group_remit.agreement.cooperative}</u></b>", inline_format: true}
    move_down 10

    muni = @pro_cov.group_remit.agreement.cooperative.municipality
    prov = @pro_cov.group_remit.agreement.cooperative.province
    reg = @pro_cov.group_remit.agreement.cooperative.region
    font_size(10) { text "Address <b><u>#{muni}, #{prov}, #{reg}</u></b>", inline_format: true}
    

    move_down 20
  end

  def count_table
    table_data = [
      ["Count", "Amount of Coverage", "Effectivity", "Expiry", "Premium Due"],
      [@pro_cov.group_remit.batches.count, @view.to_currency(@total_life_cov), @pro_cov.effectivity, @pro_cov.expiry, @view.to_currency(@pro_cov.group_remit.batches.sum(:premium))]
    ]
    
    table table_data, position: :center
    
    move_down 30
  end

  def denied_table
    denied_batches = @pro_cov.group_remit.batches.where(insurance_status: "denied")
    total_denied_cov = ProductBenefit.joins(agreement_benefit: :batches).where('batches.id IN (?)', denied_batches.pluck(:id)).where('product_benefits.benefit_id = ?', 1).sum(:coverage_amount)
    table_data = [[{content: "<b>DENIED MEMBERS</b>", colspan: 3, align: :center, inline_format: true}]]
    table_data += [
      ["Coverage Count", "Premium", "Coverage"],
      [@pro_cov.denied_count, @view.to_currency(denied_batches.sum(:premium)), @view.to_currency(total_denied_cov)],
      [
        {content: "<i>Service Fee         #{@view.to_currency(0)}</i>\n <i>Total Denied Premium Fee         #{@view.to_currency(denied_batches.sum(:premium))}</i>", colspan: 3, align: :right, inline_format: true}
      ]
    ]

    table table_data
  end

end