class UserLevel < ApplicationRecord
  belongs_to :user
  belongs_to :authority_level
end
