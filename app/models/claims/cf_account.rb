class Claims::CfAccount < ApplicationRecord
  belongs_to :cooperative

  enum status: {
    active: 0,
    deactivate: 1
  }
end
