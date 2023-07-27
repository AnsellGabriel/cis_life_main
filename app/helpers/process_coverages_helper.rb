module ProcessCoveragesHelper

  def approve_deny_button_pro_cov(rank, status)
    if rank == "analyst"
      
      case status
        when "for_process", "pending" then "d-inline"
        when "approved", "for_head_approval", "for_vp_approval" then "d-none"
      end
    elsif rank == "head" 
      
      case status 
        when "for_vp_approval", "approved" then "d-none"
        when "for_head_approval" then "d-inline"
      end

    elsif rank == "senior_officer"

      case status 
        when "for_vp_approval" then "d-inline"
        when "approved" then "d-none"
      end
      
    end
  end

  def batch_buttons(rank, status)
    if rank == "analyst"
      case status
        when "approved", "denied" then "d-none"
        when "pending", "for_review" then "d-inline"
      end
    elsif rank == "head" || rank == "senior_officer"
      "d-inline"
    end
  end
  
end