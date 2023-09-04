class BatchHealthDecsController < InheritedResources::Base
  before_action :authenticate_user!
  before_action :set_batch, only: %i[new create show]
  before_action :set_group_remit, only: %i[create]

  def show 
    @member = @batch.member_details
    @batch_health_dec = @batch.health_declaration
    @group_remit = @batch.group_remit
  end

  def new
    @batch_health_dec = @batch.health_declaration.build
    @member = @batch.member_details
    @questionaire = HealthDec.where(active: true)
  end

  def create    
    health_dec = HealthDeclarationService.new(@batch, params[:question])
    result = health_dec.process_health_declaration
    
    if result == true
      redirect_to health_dec_group_remit_batch_path(@group_remit, @batch, batch_type: @batch.class.name), notice: "Health declaration saved!"
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
      
      @batch = case params[:batch_type]
              when "LoanInsurance::Batch"
                LoanInsurance::Batch.find(params[:batch_id])
              else
                Batch.find(params[:batch_id])
              end
    end

    def set_group_remit
      @group_remit = GroupRemit.find(params[:group_remit_id])
    end
end