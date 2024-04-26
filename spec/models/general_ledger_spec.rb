require 'rails_helper'

RSpec.describe GeneralLedger, type: :model do
  describe 'associations' do
    it { should belong_to(:account) }
    it { should belong_to(:ledgerable) }
  end

  describe 'validations' do
    it { should validate_presence_of(:account_id) }
    it { should validate_presence_of(:ledgerable_id) }
    it { should validate_presence_of(:ledgerable_type) }
    it { should validate_presence_of(:amount) }
    it { should validate_presence_of(:description) }
    it { should validate_presence_of(:ledger_type) }
  end
end
