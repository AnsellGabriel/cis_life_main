
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

    font "Roboto", size: 9, leading: 150

    @h = (bounds.top/2) - 35 # top: 769.89 ~ 385 height
    @w = bounds.right # right: 523.28 ~ 261 width

    # define_grid(columns: 24, rows: 12, gutter: 10)

    letterhead
    title_block
    upper_part
    count_table

    @y2 = cursor - 15
    denied_table
    amount_summary

    # amount_summary
    signatories

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
    font_size(10) { text "Group Batch ID <b>#{@pro_cov.id}</b>", inline_format: true }
    font_size(10) { text "Group Batch Date <b>#{@pro_cov.created_at.strftime('%B %d, %Y')}</b>", inline_format: true}
    move_down 10

    font_size(10) { text "OR Number <b>#{@pro_cov.get_or_number}</b>", inline_format: true }
    font_size(10) { text "OR Date <b>#{@pro_cov.get_or_date == "-" ? @pro_cov.get_or_date : @view.to_longdate(@pro_cov.get_or_date)}</b>", inline_format: true }
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
      [@pro_cov.group_remit.count_approved_batches, @view.to_currency(@total_life_cov), effectivity.strftime("%m/%d/%Y"), expiry.strftime("%m/%d/%Y"),
      @view.to_currency(@pro_cov.group_remit.sum_approved_batches_premium)]
    ]

    table table_data, position: :center

    move_down 10
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


    bounding_box([0, @y2], width: (@w/2)-10, height: 120) do
      # bounding_box([(@w/2)+5, @y2], width: (@w/2)-5, height: 120) do
        # transparent(0.5) { stroke_bounds }
  
        # text "INSURANCE COVERAGE", style: :bold, align: :center
  
        y_position = cursor
        x_position = bounds.right * 0.4
        table table_data
  
       
    end

    # bounding_box([0, 400], width: 300) do
    #   table table_data
    # end

    # bounding_box([350, 400], width: 200) do
    #   amount_summary
    # end
    # bounding_box([0, @y2], width: (@w/2)-10, height: 120) do
    #     table_data
    #   end

  end

  def amount_summary
    bounding_box([(@w/2)+60, @y2-10], width: (@w/2)-10, height: 120) do
      y_position = cursor
      x_position = bounds.right * 0.4
      bounding_box([0, y_position], width: x_position) do
        text "Premium Due", leading: 2
        if @pro_cov.get_plan_acronym == "LPPI"
          text "Unuse Premium", leading: 2
        end
        text "Less: Service Fee", leading: 2
        pad(5) {stroke_horizontal_rule}
        text "Net Premium", leading: 2
        pad(5) {stroke_horizontal_rule}
        # text "", leading: 2
        # text "MV File No.", leading: 2
      end
      # text "Color", leading: 2
      bounding_box([x_position, y_position], width: (bounds.right - x_position)) do
        text "#{@view.to_currency(@pro_cov.group_remit.sum_approved_batches_premium)} ", leading: 2
        if @pro_cov.get_plan_acronym == "LPPI"
          text "#{@view.to_currency(@pro_cov.group_remit.sum_approved_batches_unused)} ", leading: 2
        end
        text "#{@view.to_currency(@pro_cov.group_remit.sum_approved_batches_sf)} ", leading: 2
        pad(5) {stroke_horizontal_rule}
        text "<b>#{@view.to_currency(@pro_cov.group_remit.sum_approved_batches_net_prem)}</b> ", leading: 2, inline_format: true
        pad(5) {stroke_horizontal_rule}
  
      end
    end
  end

  def signatories
    move_down 50
    unless @pro_cov.check_approver == true

      font_size(10) { text "Processed by:", inline_format: true}
  
      move_down 10
  
      # font_size(10) { text "<b>#{@pro_cov.processor.signed_fullname}</b>", inline_format: true}
      if @pro_cov.who_approved.nil?
        font_size(10) { text "<b>#{@pro_cov.who_processed.signed_fullname}</b> (#{@view.to_shortdate(@pro_cov.process_date)})", inline_format: true}
        move_down 5
        
        # font_size(8) { text "<i>#{@pro_cov.processor.designation}</i>", inline_format: true }
        font_size(8) { text "<i>#{@pro_cov.who_processed.designation}</i>", inline_format: true }
      end
  
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
end
