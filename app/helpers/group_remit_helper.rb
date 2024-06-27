module GroupRemitHelper
  def group_remit_by_mis?(group_remit)
    (current_user.is_mis? and group_remit.mis_entry?)
  end

  def group_remit_by_coop?(group_remit)
    (current_user.is_coop_user? and !group_remit.mis_entry?)
  end

  def group_remit_is_payable?(group_remit)
    ((group_remit.is_for_payment? or group_remit.reupload_payment?) && (group_remit.process_coverage.approved?)) and (group_remit_by_mis?(group_remit) or group_remit_by_coop?(group_remit))
  end

  def group_remit_is_enrollable?(group_remit)
    group_remit.is_pending_or_renewal? and (group_remit_by_mis?(group_remit) or group_remit_by_coop?(group_remit))
  end

  def render_denied_members_btn(group_remit)
    if group_remit.denied_members.present?
      link_to group_remit_denied_members_path(group_remit), class: "#{small_btn('outline-danger')} position-relative" do
        content_tag(:span, 'Rejected members') +
        content_tag(:span, class: "position-absolute top-0 start-100 translate-middle badge rounded-pill bg-danger") do
          '!'
        end
      end
    end
  end

  def render_batches(group_remit, batches, agreement)
    if group_remit.batches.exists?
      render batches, group_remit: group_remit, agreement: agreement
    else
      content_tag :tr do
        content_tag :td, 'No enrolled members', colspan: 10, class: "text-center"
      end
    end
  end

  #** LPPI **#

  def render_lppi_submit_btn(group_remit)
    if group_remit.complete_health_decs?
      button_to 'Submit', submit_loan_insurance_group_remit_path(group_remit), method: :get, class: small_btn('outline-primary'), data: {turbo_confirm: 'Submit group remit?' }
    else
      content_tag :div, data: {bs_toggle: "tooltip", bs_placement: "top"}, title: "Please answer all health declaration", style: "cursor: pointer" do
        content_tag :button, class: "btn btn-sm btn-outline-primary", disabled: true do
          "Submit"
        end
      end
    end
  end

  def render_lppi_delete_btn(group_remit)
    if group_remit.is_pending_or_renewal?
      button_to "Delete Batch", loan_insurance_group_remit_path(group_remit), method: :delete, data: { turbo_confirm: 'Delete Batch?'}, class: small_btn('outline-danger')
    end
  end

  def render_lppi_form(group_remit, batch, coop_members)
    plan = group_remit.agreement.plan.acronym

    if plan == "LPPI"
      render "loan_insurance/batches/form", batch: batch, coop_members: coop_members, group_remit_id: group_remit.id
    else
      render "loan_insurance/batches/sii_form", batch: batch, coop_members: coop_members, group_remit_id: group_remit.id
    end
  end
end
