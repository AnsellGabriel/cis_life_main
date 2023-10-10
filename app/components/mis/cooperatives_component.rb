# frozen_string_literal: true

class Mis::CooperativesComponent < ViewComponent::Base
  def initialize(cooperatives:)
    @cooperatives = cooperatives
  end
end
