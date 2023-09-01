class DependentHealthDecsController < ApplicationController
  before_action :authenticate_user!
  before_action :set_batch_dependent, only: %i[new create show health_dec]
  before_action :set_group_remit, only: %i[create]

  def show 
    @dependent = @batch_dependent.member_dependent
    @batch_dependent_health_dec = @batch_dependent.health_declaration
    @group_remit = @batch_dependent.group_remit
  end

  def new
    @batch_dependent_health_dec = @batch_dependent.health_declaration.build
    @dependent = @batch_dependent.member_dependent
    @questionaire = HealthDec.where(active: true)
  end

  def create    
    health_dec = HealthDeclarationService.new(@batch_dependent, params[:question])
    result = health_dec.process_health_declaration
    
    if result == true
      redirect_to health_dec_group_remit_batch_dependent_path(@group_remit, @batch_dependent.batch, @batch_dependent), notice: "Health declaration saved!"
    elsif result.is_a?(String)
      flash[:error] = result

      respond_to do |format|
        format.html { redirect_to new_group_remit_batch_dep_health_declaration_path(@group_remit, @batch, batch_dependent_id: @batch_dependent.id) }
        format.turbo_stream { render turbo_stream: turbo_stream.update('error_notif', partial: 'layouts/notification') }
      end
      
    end
  end



  private
    def batch_health_dec_params
      params.require(:batch_health_dec).permit(:question)
    end

    def set_batch_dependent
      @batch_dependent = BatchDependent.find(params[:batch_dependent_id])
    end

    def set_group_remit
      @group_remit = GroupRemit.find(params[:group_remit_id])
    end
end
