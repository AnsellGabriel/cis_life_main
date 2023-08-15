class BatchHealthDecsController < InheritedResources::Base
  before_action :authenticate_user!
  before_action :set_batch, only: %i[new create show]
  before_action :set_group_remit, only: %i[create]

  def show 
    @member = @batch.member_details
    @batch_health_dec = @batch.batch_health_decs
    @group_remit = @batch.group_remit
  end

  def new
    @batch_health_dec = @batch.batch_health_decs.build
    @member = @batch.member_details
    @questionaire = HealthDec.where(active: true)
  end

  def create    
    result = BatchHealthDec.process_health_declaration(@batch, params[:question])

    if result == true
      redirect_to health_dec_group_remit_batch_path(@group_remit, @batch), notice: "Health declaration saved!"
    elsif result.is_a?(String)       
      flash[:error] = result

      respond_to do |format|
        format.html { redirect_to new_group_remit_batch_health_declaration_path(@group_remit, @batch) }
        format.turbo_stream { render turbo_stream: turbo_stream.update('error_notif', partial: 'layouts/notification') }
      end
      
    end
  end

  private
    def batch_health_dec_params
      params.require(:batch_health_dec).permit(:question)
    end

    def set_batch
      @batch = Batch.find(params[:batch_id])
    end

    def set_group_remit
      @group_remit = GroupRemit.find(params[:group_remit_id])
    end
end