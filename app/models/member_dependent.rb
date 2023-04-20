class MemberDependent < ApplicationRecord
  belongs_to :member
  has_many :batch_dependents, dependent: :destroy
end
