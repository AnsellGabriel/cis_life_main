module BatchDependentsHelper

  def bd_buttons(rank, status, pc_stat=nil)
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
end
