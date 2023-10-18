class AgreementDecorator < Draper::Decorator
  include Rails.application.routes.url_helpers

  delegate_all

  # Define presentation-specific methods here. Helpers are accessed through
  # `helpers` (aka `h`). You can override attributes, for example:
  #
  #   def created_at
  #     helpers.content_tag :span, class: 'time' do
  #       object.created_at.strftime("%a %m/%d/%y")
  #     end
  #   end

  def active_batches_count
    if is_lppi?
      object.group_remits.where(status: :paid).joins(:loan_batches).where("insurance_status = ?", "approved").size
    else
      object.group_remits.where(status: :paid, type: 'BatchRemit').joins(:batches).where("insurance_status = ?", "approved").size
    end
  end

  def is_lppi?
    object.plan.acronym.include?('LPPI')
  end

  def is_gyrt?
    object.plan.acronym.include?('GYRT')
  end

  def plan_acronym
    case object.plan.acronym
    when 'GYRT', 'GYRTF', 'GYRTBR', 'GYRTFR' then 'GYRT'
    else object.plan.acronym
    end
  end

  def insurance_path
    case object.plan.acronym
    when 'GYRT', 'GYRTF', 'GYRTBR', 'GYRTFR' then coop_agreement_path(object)
    when 'LPPI' then loan_insurance_group_remits_path
    end
end

end
