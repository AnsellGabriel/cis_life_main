class BatchesController < ApplicationController
  before_action :set_cooperative 

  def index
  end

  def show
  end

  def new
    @batch = Batch.new
  end

  def create
  end

  def edit
  end

  def update
  end

  def destroy
  end

  private
    def agreement_benefit_params
      params.require(:batch).permit(:name, :description, :start_date, :end_date, :status, :agreement_id, :benefit_id)
    end

    def set_cooperative
      @cooperative = current_user.userable.cooperative
    end
end
