class Anniversary < ApplicationRecord
    belongs_to :agreement
    has_many :group_remits

    validates :name, presence: true
    validate :validate_vote_amount, :on => :create

    def validate_vote_amount
        @agreement = agreement
        # @count = @agreement.anniversaries.count
        if @agreement.anniversary_type.downcase == "single" && @agreement.anniversaries.count >= 1
            errors.add(:base,"Your anniversary type is single")
        end
    end
end
