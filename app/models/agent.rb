class Agent < ApplicationRecord
  validates_presence_of :first_name, :middle_name, :last_name, :agent_group_id, :birthdate

  belongs_to :agent_group

  has_one :user, as: :userable, dependent: :destroy
  has_many :agreements

  accepts_nested_attributes_for :user

  def to_s
    test = 5
    full_name
  end

  def full_name
    "#{first_name} #{last_name}"
  end
end
