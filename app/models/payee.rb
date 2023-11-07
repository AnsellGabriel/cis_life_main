class Payee < ApplicationRecord

  def to_s
    name
  end

  def get_address
    address
  end
end
