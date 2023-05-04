class MemberDependent < ApplicationRecord
  before_validation :uppercase_fields

  belongs_to :member

  has_many :batch_dependents, dependent: :destroy
  has_many :batches, through: :batch_dependents

  def uppercase_fields
    self.last_name = self.last_name.upcase
    self.first_name = self.first_name.upcase
    self.middle_name = self.middle_name.upcase
    self.suffix = self.suffix == nil ? '' : self.suffix.upcase
    # repeat the above line for each field you want to make all caps
  end
end
