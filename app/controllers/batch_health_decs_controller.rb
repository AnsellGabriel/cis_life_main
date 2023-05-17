class BatchHealthDecsController < InheritedResources::Base
  before_action :authenticate_user!
  before_action :set_batch, only: %i[new create]

  def new
    @batch_health_dec = @batch.build_batch_health_dec
    @member = @batch.member_details
  end

  def create
    @batch_health_dec = @batch.create_batch_health_dec(batch_health_dec_params)

    respond_to do |format|
      if @batch_health_dec.save!
        format.html { redirect_to group_remit_path(@batch.group_remit), notice: "Health declaration saved!"}
      else
        format.html { render :new, status: :unprocessable_entity }
      end
    end
  end

  private
    def batch_health_dec_params
      params.require(:batch_health_dec).permit(:ans_q1, :ans_q2, :ans_q3, :ans_q3_desc, :ans_q4, :ans_q4_desc, :ans_q5_a, :ans_q5_a_desc, :ans_q5_b, :ans_q5_b_desc, :batch_id)
    end

    def set_batch
      @batch = Batch.find(params[:batch_id])
    end
end
