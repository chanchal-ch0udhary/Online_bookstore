class CartItem < ApplicationRecord
  belongs_to :cart
  belongs_to :book

  validates :quantity, numericality: { only_integer: true, greater_than: 0 }

  def total_price
    book.price * quantity
  end
end
