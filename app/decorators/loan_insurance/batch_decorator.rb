class LoanInsurance::BatchDecorator < BatchDecorator
  delegate_all

  # Define presentation-specific methods here. Helpers are accessed through
  # `helpers` (aka `h`). You can override attributes, for example:
  #
  #   def created_at
  #     helpers.content_tag :span, class: 'time' do
  #       object.created_at.strftime("%a %m/%d/%y")
  #     end
  #   end

  def prev_loan_type
    object.previous_loan.loan.name.titleize
  end

  def prev_loan_amount
    object.previous_loan.loan_amount
  end

  def prev_loan_eff_date
    object.previous_loan.effectivity_date
  end
end
