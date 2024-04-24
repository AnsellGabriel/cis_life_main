RSpec.describe Treasury::Account, type: :model do
  describe "validations" do
    let(:account) { create(:treasury_account)  }

    it "is valid with valid attributes" do
      expect(account).to be_valid
    end

    it "is not valid without a name" do
      account.name = nil
      expect(account).not_to be_valid
    end

    it "is not valid without a code" do
      account.code = nil
      expect(account).not_to be_valid
    end

    it "is not valid if code is not unique" do
      account2 = create(:treasury_account)
      account.code = account2.code
      expect(account).not_to be_valid
    end

    it "is not valid without an account_type" do
      account.account_type = nil
      expect(account).not_to be_valid
    end

    it "is not valid without an account_category" do
      account.account_category = nil
      expect(account).not_to be_valid
    end

    context "when account_category is bank" do
      it "is not valid without an account_number" do
        account.account_category = :bank
        account.account_number = nil
        expect(account).not_to be_valid
      end

      it "is not valid if account number is not all digits" do
        account.account_category = :bank
        expect(account.account_number).to match(/\A\d+\z/)
      end

      it "is not valid if account number is with alphabets" do
        account.account_category = :bank
        account.account_number = "1234A"
        expect(account).not_to be_valid
      end
    end
  end

  describe "associations" do
    # Add association tests here...
  end

  describe "methods" do
    # Add method tests here...
  end
end
