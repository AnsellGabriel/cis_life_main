require 'rails_helper'

RSpec.describe User, type: :model do
  describe 'validations' do
    it { should validate_presence_of(:email) }
    it { should validate_uniqueness_of(:email) }
    it { should validate_presence_of(:password) }
    it { should validate_length_of(:password).is_at_least(8) }
    it 'requires at least one lowercase letter, one uppercase letter, one digit, and one special character in password' do
      user = User.new(email: 'test@example.com', password: 'Password1!', password_confirmation: 'Password1!')
      expect(user.valid?).to be true
    end
    it { should validate_presence_of(:password_confirmation) }
  end
end
