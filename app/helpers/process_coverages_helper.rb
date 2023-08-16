module ProcessCoveragesHelper

  def approve_deny_button_pro_cov(rank, status)
    if rank == "analyst"
      
      case status
        when "for_process", "pending" then "d-inline"
        when "approved", "for_head_approval", "for_vp_approval", "denied", "reprocess", "reprocess_request" then "d-none"
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
      if pc_stat == "reprocess_approved"
        "d-inline"
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
      when "approved", "denied", "for_head_approval", "for_vp_approval" then "d-none"
      else
        case batch_status
          when "approved", "denied" then "d-inline"
          when "pending", "for_review" then "d-none"
        end
      end
    else
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
  
end