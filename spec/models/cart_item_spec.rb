require 'rails_helper'

RSpec.describe CartItem, type: :model do
  let(:cart) { Cart.create }
  let(:book) { Book.create(title: "Sample Book", author: "John Doe", description: "This is a sample book description.", price: 9.99, stock_quantity: 10) }
  subject {
    described_class.new(
      cart: cart,
      book: book,
      quantity: 2
    )
  }

  context 'associations' do
    it { should belong_to(:cart) }
    it { should belong_to(:book) }
  end

  context 'validations' do
    it 'is valid with valid attributes' do
      expect(subject).to be_valid
    end

    it 'is not valid without a cart' do
      subject.cart = nil
      expect(subject).to_not be_valid
    end

    it 'is not valid without a book' do
      subject.book = nil
      expect(subject).to_not be_valid
    end

    it 'is not valid without a quantity' do
      subject.quantity = nil
      expect(subject).to_not be_valid
    end

    it 'is not valid with a non-integer quantity' do
      subject.quantity = 1.5
      expect(subject).to_not be_valid
    end

    it 'is not valid with a quantity less than 1' do
      subject.quantity = 0
      expect(subject).to_not be_valid
    end
  end

  context 'methods' do
    describe '#total_price' do
      it 'calculates the total price based on book price and quantity' do
        expect(subject.total_price).to eq(book.price * subject.quantity)
      end
    end
  end
end
