module BatchHelper
  def eligible_for_health_declaration?(batch, agreement, life_benefit)
    (batch.recent? || batch.for_reconsideration?) && batch.batch_health_decs.blank? && life_benefit[0].coverage_amount > agreement.nel
  end
end
