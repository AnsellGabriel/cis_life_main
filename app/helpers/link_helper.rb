module LinkHelper
  def lppi_back_link(group_remit)
    if group_remit.agreement.plan.acronym == "LPPI"
      loan_insurance_group_remits_path
    else
      loan_insurance_group_remits_path(p: "sii")
    end
  end
end
