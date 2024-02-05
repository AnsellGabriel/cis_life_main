
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
    signatories

    boxes
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

    muni = @pro_cov.group_remit.agreement.cooperative.geo_municipality
    prov = @pro_cov.group_remit.agreement.cooperative.geo_province
    reg = @pro_cov.group_remit.agreement.cooperative.geo_region
    font_size(10) { text "Address <b><u>#{muni}, #{prov}, #{reg}</u></b>", inline_format: true}
    move_down 10

    font_size(10) { text "Agent: <b><u>#{@pro_cov.agent}</u></b>", inline_format: true}
    move_down 10

    font_size(10) { text "Insurance Plan: <b><u>#{@pro_cov.group_remit.agreement.plan}</u></b>", inline_format: true}


    move_down 20
  end

  def count_table
    effectivity = @pro_cov.effectivity.nil? ? @pro_cov.group_remit.batches.first.effectivity_date : @pro_cov.effectivity
    expiry = @pro_cov.expiry.nil? ? @pro_cov.group_remit.batches.first.expiry_date : @pro_cov.expiry
    table_data = [
      ["Count", "Amount of Coverage", "Effectivity", "Expiry", "Premium Due"],
      # [@pro_cov.group_remit.batches.count, @view.to_currency(@total_life_cov), @pro_cov.effectivity.strftime('%m/%d/%Y'), @pro_cov.expiry.strftime('%m/%d/%Y'), @view.to_currency(@pro_cov.group_remit.batches.sum(:premium))]
      [@pro_cov.group_remit.batches.count, @view.to_currency(@total_life_cov), effectivity.strftime("%m/%d/%Y"), expiry.strftime("%m/%d/%Y"),
@view.to_currency(@pro_cov.group_remit.batches.sum(:premium))]
    ]

    table table_data, position: :center

    move_down 30
  end

  def denied_table
    denied_batches = @pro_cov.group_remit.batches.where(insurance_status: "denied")
    total_denied_cov = ProductBenefit.joins(agreement_benefit: :batches).where("batches.id IN (?)", denied_batches.pluck(:id)).where("product_benefits.benefit_id = ?", 1).sum(:coverage_amount)
    table_data = [[{content: "<b>DENIED MEMBERS</b>", colspan: 3, align: :center, inline_format: true}]]
    table_data += [
      ["Coverage Count", "Premium", "Coverage"],
      [@pro_cov.group_remit.batches.where(insurance_status: :denied).count, @view.to_currency(denied_batches.sum(:premium)), @view.to_currency(total_denied_cov)],
      [
        {content: "<i>Service Fee         #{@view.to_currency(0)}</i>\n <i>Total Denied Premium Fee         #{@view.to_currency(denied_batches.sum(:premium))}</i>", colspan: 3, align: :right,
inline_format: true}
      ]
    ]

    table table_data
  end

  def signatories
    move_down 30
    unless @pro_cov.check_approver == true

      font_size(10) { text "Processed by:", inline_format: true}
  
      move_down 10
  
      # font_size(10) { text "<b>#{@pro_cov.processor.signed_fullname}</b>", inline_format: true}
      font_size(10) { text "<b>#{@pro_cov.who_processed.signed_fullname}</b> (#{@view.to_shortdate(@pro_cov.process_date)})", inline_format: true}
      
      move_down 5
  
      # font_size(8) { text "<i>#{@pro_cov.processor.designation}</i>", inline_format: true }
      font_size(8) { text "<i>#{@pro_cov.who_processed.designation}</i>", inline_format: true }
  
      move_down 30
      
    end
    font_size(10) { text "Approved by:", inline_format: true}

    move_down 10

    # font_size(10) { text "<b>#{@pro_cov.processor.emp_approver.approver.signed_fullname}</b>", inline_format: true}
    font_size(10) { text "<b>#{@pro_cov.who_approved.signed_fullname}</b> (#{@view.to_shortdate(@pro_cov.evaluate_date)})", inline_format: true}

    move_down 5
    
    # font_size(8) { text "<i>#{@pro_cov.processor.emp_approver.approver.designation}</i>", inline_format: true }
    font_size(8) { text "<i>#{@pro_cov.who_approved.designation}</i>", inline_format: true }
  end

  def boxes
    stroke_axis
    text "the cursor is here: #{cursor}"
    text "now it is here: #{cursor}"
    move_down 200
    text "on the first move the cursor went down to: #{cursor}"
    move_up 100
    text "on the second move the cursor went up to: #{cursor}"
    move_cursor_to 50
    text "on the last move the cursor went directly to: #{cursor}"
  end

end
