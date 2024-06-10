class CartsController < ApplicationController
  before_action :authenticate_user!
  before_action :set_cart

  def show
  end

  def checkout
  end

  def complete_order
    @cart.cart_items.each do |item|
      book = item.book
      book.stock_quantity -= item.quantity
      book.save
    end
    @cart.cart_items.destroy_all
    redirect_to root_path, notice: 'Order completed successfully'
  end

  private

  def set_cart
    @cart = current_user.cart
  end
end
