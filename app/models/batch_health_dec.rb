class BatchHealthDec < ApplicationRecord
  validates_inclusion_of :ans_q1, :ans_q2, :ans_q3, :ans_q4, :ans_q5_a, :ans_q5_b, in: [true, false], message: "Please answer this question."

  [:ans_q3_desc, :ans_q4_desc, :ans_q5_a_desc, :ans_q5_b_desc].each do |attribute|
    validates_presence_of attribute, if: Proc.new { |a| a.send(attribute.to_s.chomp("_desc")) == true }
  end
  
  belongs_to :batch
end
