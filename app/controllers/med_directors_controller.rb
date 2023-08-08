class MedDirectorsController < ApplicationController
  def home
    @group_remits = GroupRemit.joins(batches: :batch_health_decs).distinct
  end
end
