RSpec.describe Accounting::JournalVoucherRequest, type: :model do
  subject { build(:journal_voucher_request) }

  it { should validate_presence_of(:requestable) }
  it { should validate_presence_of(:amount) }
  it { should validate_presence_of(:status) }
  it { should validate_presence_of(:particulars) }
end
