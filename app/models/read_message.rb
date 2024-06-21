class ReadMessage < ApplicationRecord
  belongs_to :user
  belongs_to :claim_remark
end
