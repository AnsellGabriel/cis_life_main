RSpec.describe CoopBank, type: :model do
  describe 'validations' do
    it { should validate_presence_of(:cooperative_id) }
    it { should validate_presence_of(:treasury_account_id) }
    it "should not have duplicate cooperative_id and treasury_account_id" do
      coop_bank = create(:coop_bank)
      coop_bank2 = coop_bank.dup
      expect(coop_bank2).not_to be_valid
    end
  end

  describe 'associations' do
    it { should belong_to(:cooperative) }
    it { should belong_to(:treasury_account).class_name('Treasury::Account') }
  end
end
