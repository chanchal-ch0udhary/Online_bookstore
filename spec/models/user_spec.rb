require 'rails_helper'

RSpec.describe User, type: :model do
  context 'associations' do
    it { is_expected.to have_one(:cart).dependent(:destroy) }
  end

  context 'Devise modules' do
    it 'requires email' do
      user = User.new(email: nil, password: 'password')
      expect(user).to_not be_valid
      expect(user.errors[:email]).to include("can't be blank")
    end

    it 'requires password' do
      user = User.new(email: 'test@example.com', password: nil)
      expect(user).to_not be_valid
      expect(user.errors[:password]).to include("can't be blank")
    end

    it 'requires valid email' do
      user = User.new(email: 'invalid', password: 'password')
      expect(user).to_not be_valid
      expect(user.errors[:email]).to include("is invalid")
    end
  end

  context 'callbacks' do
    it 'creates a cart after user is created' do
      user = User.create(email: 'test@example.com', password: 'password')
      expect(user.cart).to be_present
    end
  end
end
