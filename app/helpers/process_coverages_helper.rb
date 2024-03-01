module ProcessCoveragesHelper

  # def show_hide(current_user, process_coverage, button_type, premium, authority_amount)
  #   for_review_count = process_coverage.count_members("for_review")
  #   denied_count = process_coverage.count_members("denied")
  #   approved_count = process_coverage.count_members("approved")
  #   pending_count = process_coverage.count_members("pending")

  #   case button_type
  #   when "approve"
  #     if current_user.analyst?
  #       if denied_count == 0 && for_review_count == 0 && pending_count == 0
  #         if premium <= authority_amount
  #           "d-inline"
  #         else 
  #           "d-none"
  #         end
  #       else
  #         "d-none"
  #       end
  #     elsif current_user.head?
  #       if for_review_count == 0 && pending_count 
  #     end
  #   end
  # end


  def show_approve_button_pc(rank, process_coverage)
    if ["approved", "denied"].include?(process_coverage.status)
      "d-none"
    else
      case rank
      when "analyst"
        if process_coverage.group_remit.batches.where(insurance_status: [:for_review, :pending, :denied]).count > 0
          "d-none"
        else
          "d-inline"
        end
      end
    end
  end

  def show_denied_button_pc(rank, process_coverage)
    if ["approved", "denied"].include?(process_coverage.status)
      "d-none"
    else
      case rank
      when "analyst"
        batches_count = process_coverage.group_remit.batches.count
        denied_count = process_coverage.group_remit.batches.where(insurance_status: :denied).count
  
        if batches_count == denied_count
          "d-inline"
        else
          "d-none"
        end
      end
    end
  end

  def show_for_head_review(rank, process_coverage)
    case rank
    when "analyst"
      denied_count = process_coverage.group_remit.batches.where(insurance_status: :denied).count
      for_review_count = process_coverage.group_remit.batches.where(insurance_status: [:for_review, :pending]).count
      if denied_count > 0 && for_review_count == 0
        "d-inline"
      else
        "d-none"
      end
    when "head"
      "d-none"
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

  def batch_buttons(rank, status, pc_stat=nil)
    if rank == "analyst"
      if pc_stat == "reprocess_approved" || pc_stat == "reassess"
        "d-inline"
      elsif pc_stat == "for_head_approval" || pc_stat == "for_vp_approval"
        "d-none"
      else
        case status
          when "approved", "denied" then "d-none"
          when "pending", "for_review" then "d-inline"
        end
      end
    elsif rank == "head" || rank == "senior_officer"
      "d-inline"
    end
  end

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
