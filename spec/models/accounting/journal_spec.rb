RSpec.describe Accounting::Journal, type: :model do
  describe 'validations' do
    it { should validate_presence_of(:date_voucher) }
    it { should validate_presence_of(:voucher) }
    it { should validate_presence_of(:payable_type) }
    it { should validate_presence_of(:payable_id) }
    it { should validate_presence_of(:particulars) }
    it { should validate_presence_of(:status) }
    it { should validate_presence_of(:audit) }
    it { should validate_presence_of(:accountant_id) }
    it { should validate_presence_of(:branch) }
  end

  describe 'class methods' do
    context '.generate_series' do
      current_year_and_month = Time.now.strftime("%Y-%m")[0, 1] + Time.now.strftime("%Y-%m")[1 + 1..-1]

      let!(:j1) { create(:journal, voucher: "#{current_year_and_month}-023") }
      let!(:j2) { create(:journal, voucher: "#{current_year_and_month}-045") }
      let!(:j3) { create(:journal, voucher: "#{current_year_and_month}-055") }

      it 'returns the latest debit advice number for the current year and month' do
        expect(Accounting::Journal.generate_series).to eq("#{current_year_and_month}-056")
      end
    end
  end
end
