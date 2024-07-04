module BatchHelper
  def eligible_for_health_declaration?(batch, agreement, life_benefit)
    (batch.recent? || batch.for_reconsideration?) && batch.batch_health_decs.blank? && life_benefit[0].coverage_amount > agreement.nel
  end

  def substandard_status(val)
    case val
    when "approved" then content_tag(:b, "APPROVED", class: "text-success")
    when "pending" then content_tag(:b, "PENDING", class: "text-secondary")
    when "denied" then content_tag(:b, "DENIED", class: "text-danger")
    end
  end

  def render_incorrect_prem(batch)
    if current_user.is_mis? and batch.system_premium != batch.premium and !batch.system_premium.nil?
      content_tag :span, "Correct premium: #{to_curr(batch.system_premium)}", class: "text-danger sm-green-text"
    end
  end
end
