class SheetPdf < Prawn::Document
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

    # define_grid(columns: 24, rows: 20, gutter: 10)
    # stroke_axis
    # show_grid
    stroke_axis
    letterhead
    titles

    @y1 = cursor - 20
    coc_block

    @y2 = cursor - 15
    coverage_block
    vehicle_block
  end

  def letterhead
    bounding_box([0, bounds.top], width: bounds.right, height: 75) do
      image Rails.root.join("app/assets/images/cis_logo.png"), width: 65

      bounding_box([75, bounds.top], width: bounds.right) do
        move_down 10
        font_size(12) { text "1 COOPERATIVE INSURANCE SYSTEM OF THE PHILIPPINES (1CISP)", style: :bold, leading: 2 }
        font_size(12) { text "Life and General Insurance", style: :bold, leading: 2 }
        move_down 2
        font_size(7.5) do 
          text "11 Mapagbigay corner Maunlad St., Brgy. Pinyahan, 1100 Quezon City", inline_format: true
        end
      end
    end
  end

  def titles
    font_size(14) { text "PROCESSING SHEET", style: :bold, align: :center }
    move_down 8
    font_size(12) do
      text "#{@pro_cov.group_remit} Insurance", style: :bold, align: :center
      text "(#{@pro_cov.group_remit.agreement.plan})", style: :bold, align: :center
    end
    move_down 20
    text "Process Coverage ID: #{@pro_cov.id}", leading: 3
    text "Process Coverage Date: #{@view.to_longdate(@pro_cov.created_at)}", leading: 3
    move_down 20
  end

  def coc_block
    bounding_box([@w/2, @y1], width: @w/2) do
      # transparent(0.5) { stroke_bounds }
      font_size(12) { text "CONFIRMATION OF COVER", style: :bold, align: :center, leading: 2 }
      text "Land Tranportation Operators Vehicle", align: :center
      move_down 15
      text "COC No. <b>2</b>", inline_format: true, align: :center
      move_down 5
      font_size(12) { text "NOT AUTHENTICATED!", color: 'CC0000', align: :center }
      font_size(12) { text "####", align: :center, style: :bold }
      move_down 5
      # text "#{copy_for} COPY", align: :center, style: :bold
    end
  end

  def coverage_block
    bounding_box([0, @y2], width: (@w/2)-10, height: 120) do
    # bounding_box([(@w/2)+5, @y2], width: (@w/2)-5, height: 120) do
      # transparent(0.5) { stroke_bounds }

      text "INSURANCE COVERAGE", style: :bold, align: :center
      pad(5) {stroke_horizontal_rule}

      y_position = cursor
      x_position = bounds.right * 0.4
      bounding_box([0, y_position], width: x_position) do
        # transparent(0.5) { stroke_bounds }
        text "OR No.", leading: 2
        text "OR Date", leading: 2
        move_down 4
      end
      bounding_box([x_position, y_position], width: (bounds.right - x_position)) do
        text @pro_cov.get_or_number, align: :right, leading: 2
        text @pro_cov.get_or_date == "-" ? @pro_cov.get_or_date : @view.to_longdate(@pro_cov.get_or_date), align: :right, leading: 2
        move_down 5
      end

      move_down 10
      text "SECTIONS I & II", style: :bold, align: :center
      text "COMPULSORY THIRD PARTY LIABILITY", style: :bold, align: :center
      text "SUBJECT TO THE SCHEDULE OF INDEMNITIES", align: :center
    end
  end

  def vehicle_block
    # bounding_box([0, @y2], width: (@w/2)-5, height: 120) do
    bounding_box([(@w/2)+10, @y2], width: (@w/2)-10, height: 120) do
    # transparent(0.5) { stroke_bounds }

      text "SCHEDULED VEHICLE", style: :bold, align: :center
      pad(5) { stroke_horizontal_rule }
      font_size(12) { text "Vehicle Name" }
      # text @motor_risk.other_info, leading: 3 if  @motor_risk.other_info

      move_down 15
      y_position = cursor
      x_position = bounds.right * 0.4
      bounding_box([0, y_position], width: x_position) do
        text "Premium Due", leading: 2
        if @pro_cov.get_plan_acronym == "LPPI"
          text "Unuse Premium", leading: 2
        end
        text "Less: Service Fee", leading: 2
        text "Net Premium", leading: 2
        # text "", leading: 2
        # text "MV File No.", leading: 2
        # text "Color", leading: 2
      end
      bounding_box([x_position, y_position], width: (bounds.right - x_position)) do
        text "#{@view.to_currency(@pro_cov.group_remit.sum_approved_batches_premium)} ", leading: 2
        if @pro_cov.get_plan_acronym == "LPPI"
          text "#{@view.to_currency(@pro_cov.group_remit.sum_approved_batches_unused)} ", leading: 2
        end
        text "#{@view.to_currency(@pro_cov.group_remit.sum_approved_batches_sf)} ", leading: 2
        text "<b>#{@view.to_currency(@pro_cov.group_remit.sum_approved_batches_net_prem)}</b> ", leading: 2, inline_format: true

      end

    end
  end
end