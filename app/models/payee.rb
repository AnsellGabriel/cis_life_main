class Payee < ApplicationRecord
  validates_presence_of :payee_type
  # validates_presence_of :cooperative_id, if: :cooperative?
  # validates :name, presence: true, uniqueness: true

  belongs_to :cooperative, optional: true

  enum payee_type: { cooperative: 0, individual: 1, others: 2}

  def get_address
    address
  end

  private

  def self.ransackable_attributes(auth_object = nil)
    ['name']
  end
end
