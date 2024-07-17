class ClaimsPdf < Prawn::Document
  include ApplicationHelper
  def initialize(process_claim, view)
    super(
      top_margin: 70,
      # page_size: 'A4',
      page_size: [612, 1008],
      page_layout: :portrait
    )
    @view = view
    @pc = process_claim
    text "CLAIMS PROCESSING SHEET", size: 10, style: :bold, align: :center
    text "CLAIM ID# #{@pc.id}", size: 9, align: :center
    move_down 10
    cur = cursor
    
    insured_information
    # claim_details
    insurance_details(cur)
    # benefit_distribution(cur)
    move_down 10
    claim_coverage
    cur2 = cursor
    processing_steps(cur2)
    claim_remarks(cur2)
  end

  def num_format(num)
    @view.number_to_currency(num, :unit => "")
  end

  def insured_information 
    bounding_box([0, cursor], width: 300, height: 200) do
      #  transparent(0.5) { stroke_bounds }
      gap = 20
      y_position = cursor
      text "I. Insured Information", size: 10, style: :bold
      move_down 10
      indent(10) do
        bounding_box([0, y_position - gap], width: 200, height: 150) do
          text "Insured:", size: 9
        end
        bounding_box([100, y_position - gap], width: 190, height: 20) do
          text @pc.coop_member.get_fullname.titleize, size: 9, style: :bold
          text "Birthdate: #{to_shortdate(@pc.coop_member.birthdate)} Age: #{@pc.age}", size: 9
          # transparent(0.5) { stroke_bounds }
        end
        y_position -= 25
        bounding_box([0, y_position - gap], width: 200, height: 150) do
          text "Cooperative:", size: 9
        end
        bounding_box([100, y_position - gap], width: 190, height: 50) do
          text @pc.cooperative.name.titleize, size: 9, style: :bold
          text @pc.cooperative.get_address, size: 9
          # transparent(0.5) { stroke_bounds }
        end
      end
      claim_details
    end
    
  end
  
  def claim_details
    bounding_box([0, cursor], width: 300, height: 230) do
      # transparent(0.5) { stroke_bounds }
      text "II. Claim Details", size: 10, style: :bold
      move_down 10
      indent(10) do
        y_position = bounds.top
        gap = 15
        y_position -= gap
        bounding_box([0, y_position], width: 100, height: 10) do
          
          text "Date Incident:", size: 9
        end
        bounding_box([100, y_position], width: 180, height: 10) do
          text to_shortdate(@pc.date_incident), size: 9
        end
        y_position -= gap
        bounding_box([0, y_position], width: 100, height: 10) do
          # transparent(0.5) { stroke_bounds }
          text "Claim Type:", size: 9
        end
        
        bounding_box([100, y_position], width: 180, height: 10) do
          # transparent(0.5) { stroke_bounds }
          text @pc.claim_type.name, size: 9
        end
        y_position -= gap
        bounding_box([0, y_position], width: 100, height: 10) do
          # transparent(0.5) { stroke_bounds }
          text "Nature of Claim:", size: 9
        end
        
        bounding_box([100, y_position], width: 180, height: 10) do
          # transparent(0.5) { stroke_bounds }
          text @pc.claim_type_nature.name, size: 9
        end
        y_position -= gap
        bounding_box([0, y_position], width: 100, height: 10) do
          text "Cause:", size: 9
        end
        bounding_box([100, y_position], width: 180, height: 10) do
          text @pc.cause.name, size: 9
        end
        y_position -= gap
        unless @pc.claim_cause.nil?
          unless @pc.claim_cause.acd == ""
            bounding_box([0, y_position], width: 100, height: 10) do
              text "ACD:", size: 9
            end
            bounding_box([100, y_position], width: 190) do
              # transparent(0.5) { stroke_bounds }
              text @pc.claim_cause.acd, size: 9, align: :justify
            end
          end
          unless @pc.claim_cause.ucd == ""
            y_position = cursor - 5
            bounding_box([0, y_position], width: 100, height: 10) do
              text "OSCCD:", size: 9
            end
            bounding_box([100, y_position], width: 190) do
              # transparent(0.5) { stroke_bounds }
              text @pc.claim_cause.ucd, size: 9, align: :justify
            end
          end
          unless @pc.claim_cause.osccd == ""
            y_position = cursor - 5
            bounding_box([0, y_position], width: 100, height: 10) do
              text "OSCCD:", size: 9
            end
            bounding_box([100, y_position], width: 190) do
              # transparent(0.5) { stroke_bounds }
              text @pc.claim_cause.osccd, size: 9, align: :justify
            end
          end
          unless @pc.claim_cause.icd == ""
            y_position = cursor - 5
            bounding_box([0, y_position], width: 100, height: 10) do
              text "OSCCD:", size: 9
            end
            bounding_box([100, y_position], width: 190) do
              # transparent(0.5) { stroke_bounds }
              text @pc.claim_cause.icd, size: 9, align: :justify
            end
          end
          unless @pc.claim_confinements.empty? 
            data = [["Admit", "Discharge", "Days", "Amount"]]
            @pc.claim_confinements.each do |cc|
              data += [["#{cc.date_admit}", "#{cc.date_discharge}", "#{cc.terms}", "#{num_format(cc.amount)}"]]
            end
            table data do
              row(0).font_style = :bold
              columns(3).align = :right
              self.column_widths = [60,60,40,80]
              self.cell_style = {:size => 8}
            end
          end
        end
      end
    end
  end

  def insurance_details(cur)
    y_position = cur
    bounding_box([310, y_position], width: 220, height: 230) do
      transparent(0.5) { stroke_bounds }
      text "III. Insurance Details", size: 10, style: :bold
      
      indent(10) do
        y_position = bounds.top
        gap = 20
        y_position -= gap
        bounding_box([0, y_position], width: 100, height: 10) do
          text "Plan:", size: 9
        end
        bounding_box([50, y_position], width: 180) do
          text @pc.agreement.plan.name, size: 9
        end
        move_down 10
        data = [["Benefit(s)", "Amount"]]
        @pc.claim_benefits.each do |cb| 
          data += [["#{cb.benefit.name}","#{num_format(cb.amount)}"]]
        end
        data += [["Total","#{num_format(@pc.claim_benefits.sum(:amount))}"]]
        table data do
          row(0).font_style = :bold
          columns(1).align = :right
          self.column_widths = [130,80]
          self.cell_style = {:size => 8}
        end
      end
      move_down 10
      benefit_distribution
    end
  end

  def processing_steps(cur)
    y_position = cur - 20
    bounding_box([310, y_position], width: 220) do
      # transparent(0.5) { stroke_bounds }
      y_position = y_position
      gap = 20
      text "VII. Processing Steps", size: 10, style: :bold
      move_down 10
      y_position -= gap
      indent(10) do
        y_position = bounds.top
        data = [["Process", "Date"]]
        @pc.process_track.order(created_at: :desc).each do |ct|
          data += [[ "#{Claims::ProcessClaim.get_route(ct.route_id).to_s.humanize.titleize} 
                 by #{ct.user}", "#{to_shortdate(ct.created_at)}" ]]
          # bounding_box([0, y_position - gap], width: 120, height: 20) do
          #   transparent(0.5) { stroke_bounds }
          #   text ProcessClaim.get_route(ct.route_id).to_s.humanize.titleize, size: 9
          #   text "#{ct.description} by #{ct.user}", size: 7
          # end
          # bounding_box([120, y_position - gap], width: 80, height: 20) do
          #   transparent(0.5) { stroke_bounds }
          #   text to_shortdate(ct.created_at), size: 9
          # end
          y_position -= gap
        end
        table data do
          row(0).font_style = :bold
          columns(1).align = :center
          self.column_widths = [130,80]
          self.cell_style = {:size => 8}
        end
      end
    end
  end

  def claim_coverage 
    bounding_box([0, cursor], width: 530) do
      # transparent(0.5) { stroke_bounds }
      text "V. Policy Coverage", size: 10, style: :bold
      indent(10) do 
        data = [["ORNO", "ORdate", "Effectivity","Expiry","Amount Insured","Benefit","Status","Duration","#"]]
        data += [[ {content: "Current", colspan: 9} ]]
        i = 1
        @pc.claim_coverages.where(coverage_type: "Current").each do |cc|
          data += [["#{cc.orno}","#{to_shortdate(cc.or_date)}","#{to_shortdate(cc.effectivity)}","#{to_shortdate(cc.expiry)}","#{num_format(cc.amount)}","#{num_format(cc.amount_cover)}","#{cc.status}","#{cc.get_duration}",i]]
          i += 1
        end
        previous = @pc.claim_coverages.where(coverage_type: "Previous")
        unless previous.empty?
          data += [[ {content: "Previous", colspan: 9} ]]
          previous.each do |cc|
            data += [["#{cc.orno}","#{to_shortdate(cc.or_date)}","#{to_shortdate(cc.effectivity)}","#{to_shortdate(cc.expiry)}","#{num_format(cc.amount)}","#{num_format(cc.amount_cover)}","#{cc.status}","#{cc.get_duration}",i]]
          end
        end
        table data do
          row(0).font_style = :bold
          # columns(0).align = :center
          columns(4..6).align = :right
          self.column_widths = [40,60,60,60,60,60,40,110]
          self.cell_style = {:size => 8}
        end
      end
    end
  end

  def claim_remarks(cur)
    bounding_box([0, cur - 20], width: 300) do
      bounding_box([0, bounds.top], width: 300) do
        # transparent(0.5) { stroke_bounds }
        text "VI. Recommendations", size: 10, style: :bold
        move_down 10
        # data = [[ "User", "Status", "Recommendations" ]]

        # @pc.claim_remarks.where.not(status: nil).each do |cr|
        #   data += [[ "#{cr.user.userable.get_fullname}", "#{cr.status.titleize}", "#{cr.remark}" ]]
        # end
        indent(10) do
          @pc.claim_remarks.where(coop: 0).each do |cr|
            status = ""
            status += "(#{cr.status.titleize})" unless cr.status.nil?
            
            text "<b>#{cr.user.userable.get_fullname} </b><b>" + status + "</b>" + "<i> #{cr.created_at} </i>" , size: 8, inline_format: true
            text cr.remark, size: 8, align: :justify
            move_down 10
          end
          # table data do
          #   row(0).font_style = :bold
          #   # columns(4..6).align = :right
          #   self.column_widths = [120,50,300]
          #   self.cell_style = {:size => 8}
          # end
        end
      end
      # bounding_box([310, bounds.top], width: 230, height: 200) do
      #   # transparent(0.5) { stroke_bounds }
      #   text "VII. Benefit Distribution", size: 10, style: :bold

      #   data = [["Pariculars", "Amount"]]
      #   data += [["Piwong Multi-Purpose Cooperative","#{num_format(149000)}"]]
      #   data += [["Total",num_format(149000)]]
      #   indent(10) do
      #     table data do
      #           row(0).font_style = :bold
      #           columns(1).align = :right
      #           self.column_widths = [140,80]
      #           self.cell_style = {:size => 8}
      #     end
      #   end
      # end
    end
  end

  def benefit_distribution
    # y_position = cur 
    # bounding_box([310, y_position], width: 220, height: 120) do
      # transparent(0.5) { stroke_bounds }
      text "IV. Benefit Distribution", size: 10, style: :bold

      data = [["Pariculars", "Amount"]]
      @pc.claim_distributions.each do |cd|
        data += [["#{cd.name} (#{cd.relationship})","#{num_format(cd.amount)}"]]
      end
      # data += [["Total","#{@pc.claim_distributions.sum(:amount)}"]]
      indent(10) do
        table data do
              row(0).font_style = :bold
              columns(1).align = :right
              self.column_widths = [130,80]
              self.cell_style = {:size => 8}
        end
      end
    # end
  end


end