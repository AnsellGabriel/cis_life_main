module ProcessCoveragesHelper

  def button_show_pc(rank, process_coverage, net_premium, btn_type)
    total_batches = process_coverage.group_remit.batches.count
    batches_for_review = process_coverage.group_remit.batches.where(insurance_status: :for_review).count
    batches_approved = process_coverage.group_remit.batches.where(insurance_status: :approved).count
    batches_denied = process_coverage.group_remit.batches.where(insurance_status: :denied).count
    batches_pending = process_coverage.group_remit.batches.where(insurance_status: :pending).count
    status = process_coverage.status
        
    case btn_type
    when "approve", "deny"
      batches_selected = btn_type == "approve" ? batches_approved : batches_denied      
      case rank
      when "analyst"
        if status == "for_process" || status == "reprocess_approved"
          if total_batches == batches_selected
            if net_premium <= session[:max_amount]
              "d-inline"
            else 
              "d-none"
            end
          else
            "d-none"
          end
        else
          "d-none"
        end
      when "head"
        if ["for_process", "approved", "denied", "for_vp_approval", "reassess", "reprocess_request", "reprocess_approved"].include?(status)
          "d-none"
        else
          if batches_for_review > 0
            "d-none"
          else
            if (btn_type == "approve" ? true : total_batches == batches_selected )
              
              if net_premium <= session[:max_amount]
                "d-inline"
              else
                "d-none"
              end
            else 
              "d-none"
            end
          end
        end
      when "senior_officer"
        if ["for_process", "approved", "denied", "for_head_approval", "reassess", "reprocess_request", "reprocess_approved"].include?(status)
          "d-none"
        else
          "d-inline"
        end
      end

    when "for_head_review"
      case rank
      when "analyst"
        if status == "for_process"
          if batches_denied > 0 || net_premium > session[:max_amount]
            "d-inline"
          else
            "d-none"
          end
        else
          "d-none"
        end
      when "head"
        "d-none"
      when "senior_officer"
        if status == "for_vp_approval"
          "d-inline"
        else
          "d-none"
        end
      end

    when "for_vp_review"
      case rank
      when "analyst", "senior_officer"
        "d-none"
      when "head"
        if session[:max_amount] < net_premium
          "d-inline"
        else
          "d-none"
        end
      end
      
    when "reassessment"
      case rank
      when "analyst"
        "d-none"
      when "head"
        if ["approved", "denied"].include?(status)
          "d-inline"
        else
          "d-none"
        end
      when "senior_officer"
        "d-none"
      end

    when "re_approve"
      case rank
      when "analyst"
        "d-none"
      when "head", "senior_officer"
        if status == "reprocess_request"
          "d-inline"
        else
          "d-none"
        end
      end
    end
  
  end
  
  def batch_buttons(rank, type, b_status, p_status)
    case type
    when "approve", "deny", "pending"
      case rank
      when "analyst"
        if p_status == "for_process" 
          if b_status == "for_review"
            "d-inline"
          else
            "d-none"
          end
        elsif p_status == "reprocess_approved"
          "d-inline"
        else
          "d-none"
        end
      when "head"
        if p_status == "for_head_approval"
          "d-inline"
        else
          "d-none"
        end
      when "senior_officer"
        if p_status == "for_vp_approval"
          "d-inline"
        else
          "d-none"
        end
      end
    end
  end

  def button_show_batch(rank, batch_status, process_coverage)
    case rank
    when "analyst"
      case process_coverage.status
      when "for_process", "reprocess_approved"
        "d-inline"
      when "denied", "approved", "for_head_review", "for_vp_review", "reprocess_request"
        "d-none" 
      end
    end
  end

  def show_for_vp_review(rank, process_coverage)
    case rank
    when "head"
      "d-inline"
    when "analyst"
      "d-none"
    end
  end

  def approve_deny_button_pro_cov(rank, process_coverage)
    if rank == "analyst"

      if process_coverage.group_remit.batches.where(insurance_status: [:for_review, :pending, :denied]).count > 0
        "d-none"
      else
        "d-inline"
      end

    elsif rank == "head"

      case status
        when "for_vp_approval", "approved", "reprocess", "reprocess_request" then "d-none"
        when "for_head_approval" then "d-inline"
      end

    elsif rank == "senior_officer"

      case status
        when "for_vp_approval" then "d-inline"
        when "approved", "reprocess" then "d-none"
      end

    end
  end

  # def batch_buttons(rank, status, pc_stat=nil)
  #   if rank == "analyst"
  #     if pc_stat == "reprocess_approved" || pc_stat == "reassess"
  #       "d-inline"
  #     elsif pc_stat == "for_head_approval" || pc_stat == "for_vp_approval"
  #       "d-none"
  #     else
  #       case status
  #         when "approved", "denied" then "d-none"
  #         when "pending", "for_review" then "d-inline"
  #       end
  #     end
  #   elsif rank == "head" || rank == "senior_officer"
  #     "d-inline"
  #   end
  # end

  def reconsider_button(rank, batch_status, pro_cov_status)
    if rank == "analyst"
      case pro_cov_status
        when "approved", "denied", "for_head_approval", "for_vp_approval", "reprocess_request" then "d-none"
        # when "reprocess_approved" then "d-inline"
      else
        case batch_status
          when "approved", "denied" then "d-inline"
          when "pending", "for_review" then "d-none"
        end
      end
    else
      # "d-none"
      "d-none"
    end
  end

  def reprocess_stat(val=nil)
    case val
    when true then content_tag :span, "YES", class: "text-success"
    else
      content_tag :span, "NO", class: "text-secondary"
    end
  end

  def substandard(val=nil)
    case val
      when true then content_tag :span, "substandard", class: "badge bg-primary"
    end
  end

  def check_md_reco(batch)
    if batch.batch_remarks.where(status: :md_reco).count > 0
      "table-warning"
    elsif batch.approved?
      "table-success"
    elsif batch.denied?
      "table-danger"
    elsif batch.pending?
      "table-secondary"
    end
  end
  

end
