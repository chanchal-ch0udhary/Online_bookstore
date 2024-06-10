require 'rails_helper'

RSpec.describe Book, type: :model do
  subject {
    described_class.new(
      title: "Sample Book",
      author: "John Doe",
      description: "This is a sample book description.",
      price: 9.99,
      stock_quantity: 10
    )
  }

  context 'validations' do
    it 'destroys associated cart_items when destroyed' do
      book = create(:book)
      create_list(:cart_item, 2, book: book)
  
      expect { book.destroy }.to change { CartItem.count }.by(-2)
    end
    
    it 'is valid with valid attributes' do
      expect(subject).to be_valid
    end

    it 'is not valid without a title' do
      subject.title = nil
      expect(subject).to_not be_valid
    end

    it 'is not valid without an author' do
      subject.author = nil
      expect(subject).to_not be_valid
    end

    it 'is not valid without a description' do
      subject.description = nil
      expect(subject).to_not be_valid
    end

    it 'is not valid without a price' do
      subject.price = nil
      expect(subject).to_not be_valid
    end

    it 'is not valid with a negative price' do
      subject.price = -1
      expect(subject).to_not be_valid
    end

    it 'is not valid without a stock quantity' do
      subject.stock_quantity = nil
      expect(subject).to_not be_valid
    end

    it 'is not valid with a non-integer stock quantity' do
      subject.stock_quantity = 1.5
      expect(subject).to_not be_valid
    end

    it 'is not valid with a negative stock quantity' do
      subject.stock_quantity = -1
      expect(subject).to_not be_valid
    end
  end
end
