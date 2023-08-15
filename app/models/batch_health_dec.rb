class BatchHealthDec < ApplicationRecord
  # validates_inclusion_of :ans_q1, :ans_q2, :ans_q3, :ans_q4, :ans_q5_a, :ans_q5_b, in: [true, false], message: "Please answer this question."

  # [:ans_q3_desc, :ans_q4_desc, :ans_q5_a_desc, :ans_q5_b_desc].each do |attribute|
  #   validates_presence_of attribute, if: Proc.new { |a| a.send(attribute.to_s.chomp("_desc")) == true }
  # end
  
  belongs_to :batch
  belongs_to :answerable, polymorphic: true


  def self.process_health_declaration(batch, questions)
    ActiveRecord::Base.transaction do
      begin
        @pre_approved_health_dec = true

        questions.each do |q_id, q_data|
          health_dec = HealthDec.find(q_id)
          answer = q_data[:answer]

          check_answer(answer)
          compare_answer(answer, health_dec)

          health_dec_answer = health_dec.batch_health_decs.build(answer: answer, batch_id: batch.id)
          health_dec_answer.save!

          sub_questions = q_data[:subquestion]
    
          if sub_questions.present? && answer == "true"
            process_subquestion(batch, sub_questions)
          end

        end
    
        batch.update!(valid_health_dec: true) if @pre_approved_health_dec
        ActiveRecord::Base.connection.commit_db_transaction
        return true
        
      rescue ActiveRecord::Rollback => e
        return e.message
      end
    end
  end

  def self.check_answer(answer)
    if answer.nil? || answer.blank?
      raise ActiveRecord::Rollback, "Please answer all questions"
    end
  end

  def self.compare_answer(answer, health_dec)
    if answer != health_dec.valid_answer.to_s
      @pre_approved_health_dec = false
    end
  end

  def self.process_subquestion(batch, sub_questions)
    sub_questions.each do |subq_id, subq_data|
      health_dec_sub = HealthDecSubquestion.find(subq_id)
      subquestion_answer = subq_data[:value]

      if subquestion_answer.blank?
        raise ActiveRecord::Rollback, "Answer cannot be blank"
      end

      subquestion_answer = health_dec_sub.batch_health_decs.build(answer: subquestion_answer, batch_id: batch.id)
      subquestion_answer.save!
    end
  end
end
