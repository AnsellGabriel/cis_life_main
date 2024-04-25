# spec/models/accounting/check_voucher_request_spec.rb
RSpec.describe Accounting::CheckVoucherRequest, type: :model do
  subject { build(:check_voucher_request) }

  describe "validations" do
    it { should validate_presence_of(:requestable_type) }
    it { should validate_presence_of(:requestable_id) }
    it { should validate_presence_of(:amount) }
    it { should validate_presence_of(:status) }
    it { should validate_presence_of(:analyst) }
    it { should validate_presence_of(:description) }
    it { should validate_presence_of(:payment_type) }
    it { should validate_presence_of(:payout_type) }

    context "when request is debit advice" do
      subject { build(:check_voucher_request, payout_type: "debit_advice") }

      it { should validate_presence_of(:bank_id) }
    end
  end
end
