RSpec.describe Accounting::DebitAdvice, type: :model do
  subject { build(:debit_advice) }

  describe 'validations' do
    it { should validate_presence_of(:date_voucher) }
    it { should validate_presence_of(:voucher) }
    it { should validate_presence_of(:payable_type) }
    it { should validate_presence_of(:payable_id) }
    it { should validate_presence_of(:treasury_account_id) }
    it { should validate_presence_of(:amount) }
    it { should validate_presence_of(:particulars) }
    it { should validate_presence_of(:status) }
    it { should validate_presence_of(:audit) }
    it { should validate_presence_of(:accountant_id) }
    it { should validate_presence_of(:branch) }
  end

  describe 'associations' do
    it { should belong_to(:check_voucher_request).optional }
  end

  describe 'class methods' do
    context '.generate_series' do
      let!(:da1) { create(:debit_advice, voucher: "#{Time.now.strftime("%Y-%m")}-023", status: :posted) }
      let!(:da2) { create(:debit_advice, voucher: "#{Time.now.strftime("%Y-%m")}-045", status: :posted) }
      let!(:da3) { create(:debit_advice, voucher: "#{Time.now.strftime("%Y-%m")}-055", status: :posted) }

      it 'returns the latest debit advice number for the current year and month' do
        expect(Accounting::DebitAdvice.generate_series).to eq("#{Time.now.strftime("%Y-%m")}-056")
      end
    end
  end
end
