class AgreementDecorator < Draper::Decorator
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
    object.group_remits.where(status: :paid).joins(:batches).size
  end

  def is_lppi?
    object.plan.acronym == 'LPPI'
  end

  def is_gyrt?
    object.plan.acronym.include?('GYRT')
  end
end
