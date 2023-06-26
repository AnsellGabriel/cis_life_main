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
    @batch_health_dec = @batch.batch_health_decs.build
    @questionaire = HealthDec.where(active: true)
    # Retrieve the form data from params
    question_params = params[:question]

    ActiveRecord::Base.transaction do
      begin
        question_params.each do |question_id, question_data|
          health_dec = HealthDec.find(question_id)
    
          if question_data[:answer].nil?
            raise ActiveRecord::Rollback, "Please answer all questions"
          end
    
          answer = health_dec.batch_health_decs.build(answer: question_data[:answer], batch_id: @batch.id)
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
    
        # All records created successfully, commit the transaction
        # If an exception occurs before this point, the transaction will be automatically rolled back
        # and no changes will be persisted to the database
        ActiveRecord::Base.connection.commit_db_transaction
        redirect_to health_dec_group_remit_batch_path(@batch.group_remit, @batch), notice: "Health declaration saved!"
        
      rescue ActiveRecord::Rollback => e
        flash.now[:error] = e.message
        respond_to do |format|
          format.html { render :new, status: :unprocessable_entity }
        end
    
        return
      end

    
    end
    


    
  end

  private
    def batch_health_dec_params
<<<<<<< HEAD
<<<<<<< HEAD
      params.require(:batch_health_dec).permit(:ans_q1, :ans_q2, :ans_q3, :ans_q3_desc, :ans_q4, :ans_q4_desc, :ans_q5_a, :ans_q5_a_desc, :ans_q5_b, :ans_q5_b_desc, :batch_id)
=======
      params.require(:batch_health_dec).permit(:question)
>>>>>>> 5d3ce79 (merge from underwriting module to main)
=======
      params.require(:batch_health_dec).permit(:question)
>>>>>>> main
    end

    def set_batch
      @batch = Batch.find(params[:batch_id])
    end
end
