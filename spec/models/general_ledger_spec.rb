RSpec.describe GeneralLedger, type: :model do
  describe "autofill" do
    context "for cashier entry" do
      let(:cashier_entry) { create(:cashier_entry) }
      let(:account) { create(:account) }
      let!(:gyrt_sf_account) { create(:account, :gyrt_service_fee) }
      let!(:lppi_sf_account) { create(:account, :lppi_service_fee) }
      let!(:gyrt_prem_account) { create(:account, :gyrt_premium_income) }
      let!(:lppi_prem_account) { create(:account, :lppi_premium_income) }

      it "should delete previous ledgers entry and add new ledger entries" do
        initial_entry = cashier_entry.general_ledgers.create(
          account: account,
          description: "Cash in - #{account.name}",
          amount: cashier_entry.amount,
          ledger_type: 0
        )

        GeneralLedger.autofill(:c_e, cashier_entry)

        expect(initial_entry).to be_destroyed
        expect(cashier_entry.general_ledgers.where(ledger_type: 0).count).to be > 0
        expect(cashier_entry.general_ledgers.where(ledger_type: 1).count).to be > 0
      end
    end

    context "for check voucher" do
      let(:check_voucher) { create(:check_voucher) }
      let(:account) { create(:account) }
      let!(:claims) { create(:account, :claims) }

      it "should delete previous ledgers entry and add new ledger entries" do
        initial_entry = check_voucher.general_ledgers.create(
          account: claims,
          description: "#{claims.name}",
          amount: check_voucher.amount,
          ledger_type: 0
        )

        GeneralLedger.autofill(:c_v, check_voucher)

        expect(initial_entry).to be_destroyed
        expect(check_voucher.general_ledgers.where(ledger_type: 0).count).to be > 0
        expect(check_voucher.general_ledgers.where(ledger_type: 1).count).to be > 0
      end
    end
  end
end
