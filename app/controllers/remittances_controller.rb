class RemittancesController < ApplicationController
  def index
    @batch_remit = BatchRemit.find(params[:group_remit_id])
    @q = Remittance.where(batch_remit_id: @batch_remit.id).ransack(params[:q])
    @remittances = @q.result(distinct: true).order(created_at: :desc)
    @pagy, @remittances = pagy(@remittances, items: 10)
  end
end
