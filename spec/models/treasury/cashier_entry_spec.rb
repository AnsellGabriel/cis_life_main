RSpec.describe Treasury::CashierEntry, type: :model do
  describe 'autofill' do
    let(:cashier_entry) { create(:cashier_entry) }
    let(:account) { create(:account) }

    let!(:gyrt_sf_account) { create(:account, :gyrt_service_fee) }
    let!(:lppi_sf_account) { create(:account, :lppi_service_fee) }
    let!(:gyrt_prem_account) { create(:account, :gyrt_premium_income) }
    let!(:lppi_prem_account) { create(:account, :lppi_premium_income) }

    it 'should delete previous ledgers entry and add new ledger entries' do
      initial_entry = cashier_entry.general_ledgers.create(
        account: account,
        description: "Cash in - #{account.name}",
        amount: cashier_entry.amount,
        ledger_type: 0
      )

      cashier_entry.autofill(cashier_entry.entriable)

      expect(initial_entry).to be_destroyed
      expect(cashier_entry.general_ledgers.where(ledger_type: 0).count).to be > 0
      expect(cashier_entry.general_ledgers.where(ledger_type: 1).count).to be > 0
    end
  end
end
