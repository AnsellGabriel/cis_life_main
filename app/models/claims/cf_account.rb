class Claims::CfAccount < ApplicationRecord
  belongs_to :cooperative
  has_many :cf_replenishes
  has_many :cf_availments

  # validates_presence_of :name

  def to_s 
    cooperative.name
  end
  
  enum status: {
    active: 0,
    deactivate: 1,
    critical: 2
  }

  def get_balance(cf_date)
    t_date = cf_date.to_datetime
    cf_ledgers = Claims::CfLedger.where(cf_account: self).where('transaction_date <= ?', t_date)
    total_debit = cf_ledgers.debit.sum(:amount)
    total_credit = cf_ledgers.credit.sum(:amount)
    total = total_debit - total_credit
    return total
  end
end
