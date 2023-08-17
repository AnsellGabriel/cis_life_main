class MedDirectorsController < ApplicationController
  before_action :authenticate_user!
  def home
    @group_remits = GroupRemit.joins(batches: :batch_health_decs).distinct
  end
end
