require 'rails_helper'

RSpec.describe Cart, type: :model do
  context 'associations' do
    it { is_expected.to belong_to(:user) }
    it { is_expected.to have_many(:cart_items).dependent(:destroy) }
  end
end
