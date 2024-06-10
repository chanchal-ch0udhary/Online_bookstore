class CartItemsController < ApplicationController
  before_action :authenticate_user!
  before_action :set_cart
  before_action :set_cart_item, only: [:edit, :update, :destroy]

  def create
    @cart_item = @cart.cart_items.find_or_initialize_by(book_id: params[:cart_item][:book_id])
    book = Book.find(params[:cart_item][:book_id])
    
    if book.stock_quantity == 0
      redirect_to @cart, alert: 'Book is out of stock.'
      return
    end
    
    requested_quantity = params[:cart_item][:quantity].to_i
    available_quantity = book.stock_quantity - @cart_item.quantity
    
    if requested_quantity > available_quantity
      @cart_item.quantity += available_quantity
      message = "Only #{available_quantity} out of #{requested_quantity} books were added to the cart due to limited stock."
    else
      @cart_item.quantity += requested_quantity
      message = 'Book was successfully added to cart.'
    end
    
    if @cart_item.save
      redirect_to @cart, notice: message
    else
      redirect_to @cart, alert: 'Unable to add book to cart.'
    end
  end
  
  def edit
  end

  def update
    requested_quantity = params[:cart_item][:quantity].to_i
    book = @cart_item.book
    
    if book.stock_quantity == 0
      redirect_to @cart, alert: 'Book is out of stock.'
      return
    end
    
    available_quantity = book.stock_quantity + @cart_item.quantity - requested_quantity
    
    if requested_quantity > available_quantity
      @cart_item.quantity = book.stock_quantity
      message = "Only #{available_quantity} out of #{requested_quantity} books can be updated in the cart due to limited stock."
    else
      @cart_item.quantity = requested_quantity
      message = 'Cart item was successfully updated.'
    end
    
    if @cart_item.save
      redirect_to @cart, notice: message
    else
      redirect_to @cart, alert: 'Unable to update cart item.'
    end
  end

  def destroy
    @cart_item.destroy
    redirect_to @cart, notice: 'Cart item was successfully removed.'
  end

  private

  def set_cart
    @cart = current_user.cart || current_user.create_cart
  end
  
  def set_cart_item
    @cart_item = @cart.cart_items.find(params[:id])
  end
end
