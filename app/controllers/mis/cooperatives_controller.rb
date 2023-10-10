class Mis::CooperativesController < ApplicationController
  def index
    @cooperatives = Cooperative.all
  end
end
