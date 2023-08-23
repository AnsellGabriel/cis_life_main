class HealthDeclarationService
  def initialize(batch, questions)
    @batch = batch
    @questions = questions
  end

  def process_health_declaration
    ActiveRecord::Base.transaction do
      begin
        @pre_approved_health_dec = true

        @questions.each do |q_id, q_data|
          health_dec = HealthDec.find(q_id)
          answer = q_data[:answer]

          check_answer(answer)
          compare_answer(answer, health_dec)

          if @batch.instance_of?(Batch)
            health_dec_answer = health_dec.batch_health_decs.build(answer: answer, batch_id: @batch.id)
          elsif @batch.instance_of?(BatchDependent)
            health_dec_answer = health_dec.dependent_health_decs.build(answer: answer, batch_dependent_id: @batch.id)
          end

          health_dec_answer.save!
          sub_questions = q_data[:subquestion]
    
          if sub_questions.present? && answer == "true"
            process_subquestion(@batch, sub_questions)
          end

        end
    
        @batch.update!(valid_health_dec: true) if @pre_approved_health_dec
        ActiveRecord::Base.connection.commit_db_transaction
        return true
        
      rescue ActiveRecord::Rollback => e
        return e.message
      end
    end
  end

  def check_answer(answer)
    if answer.nil? || answer.blank?
      raise ActiveRecord::Rollback, "Please answer all questions"
    end
  end

  def compare_answer(answer, health_dec)
    if answer != health_dec.valid_answer.to_s
      @pre_approved_health_dec = false
    end
  end

  def process_subquestion(batch, sub_questions)
    sub_questions.each do |subq_id, subq_data|
      health_dec_sub = HealthDecSubquestion.find(subq_id)
      subquestion_answer = subq_data[:value]

      if subquestion_answer.blank?
        raise ActiveRecord::Rollback, "Answer cannot be blank"
      end

      if batch.instance_of?(Batch)
        subquestion_answer = health_dec_sub.batch_health_decs.build(answer: subquestion_answer, batch_id: batch.id)
      elsif batch.instance_of?(BatchDependent)
        subquestion_answer = health_dec_sub.dependent_health_decs.build(answer: subquestion_answer, batch_dependent_id: batch.id)
      end

      subquestion_answer.save!
    end
  end
end