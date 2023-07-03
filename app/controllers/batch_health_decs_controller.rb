class BatchHealthDecsController < InheritedResources::Base
  before_action :authenticate_user!
  before_action :set_batch, only: %i[new create show]

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
    @member = @batch.member_details
    @batch_health_dec = @batch
    @questionaire = HealthDec.where(active: true)
    # Retrieve the form data from params
    question_params = params[:question]
    
    ActiveRecord::Base.transaction do
      begin
        pre_approved_health_dec = true
        
        question_params.each do |question_id, question_data|
          # byebug
          health_dec = HealthDec.find(question_id)
<<<<<<< HEAD
          
          if question_data[:answer].nil? || question_data[:answer].blank?
=======
          # byebug
          if question_data[:answer].nil?
>>>>>>> main
            raise ActiveRecord::Rollback, "Please answer all questions"
          end
    
          answer = health_dec.batch_health_decs.build(answer: question_data[:answer], batch_id: @batch.id)
          
          if question_data[:answer] != health_dec.valid_answer.to_s
            pre_approved_health_dec = false
          end

          answer.save!
    
          subquestions = question_data[:subquestion]
    
          if subquestions.present? && question_data[:answer] == "true"
            subquestions.each do |subquestion_id, subquestion_data|
              health_dec_sub = HealthDecSubquestion.find(subquestion_id)
              subquestion_answer = subquestion_data[:value]
    
              if subquestion_answer.blank?
                raise ActiveRecord::Rollback, "Answer cannot be blank"
              end
    
              subquestion_answer = health_dec_sub.batch_health_decs.build(answer: subquestion_answer, batch_id: @batch.id)
              subquestion_answer.save!
            end
          end
        end
    
<<<<<<< HEAD
        if pre_approved_helth_dec
=======
        # All records created successfully, commit the transaction
        # If an exception occurs before this point, the transaction will be automatically rolled back
        # and no changes will be persisted to the database
        if pre_approved_health_dec
>>>>>>> main
          @batch.update!(valid_health_dec: true)
        end

        ActiveRecord::Base.connection.commit_db_transaction

        

        redirect_to health_dec_group_remit_batch_path(@batch.group_remit, @batch), notice: "Health declaration saved!"
        
      rescue ActiveRecord::Rollback => e
<<<<<<< HEAD
        flash[:error] = e.message
        respond_to do |format|
          format.html { redirect_to new_group_remit_batch_health_declaration_path(@batch.group_remit, @batch) }
          format.turbo_stream { render turbo_stream: turbo_stream.replace('error_notif', partial: 'layouts/notification') }
=======
        respond_to do |format|
          format.html { redirect_to new_group_remit_batch_health_declaration_path(@batch.group_remit, @batch), alert: e.message  }
>>>>>>> main
        end
    
        return
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
end
