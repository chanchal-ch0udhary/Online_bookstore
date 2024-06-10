require 'rails_helper'

RSpec.describe CartItemsController, type: :controller do
  let(:user) { create(:user) }
  let(:book) { create(:book, stock_quantity: 5) }
  let(:cart) { create(:cart, user: user) }
  let(:cart_item) { create(:cart_item, cart: cart, book: book, quantity: 2) }

  before do
    sign_in user
    allow(controller).to receive(:current_user).and_return(user)
    allow(user).to receive(:cart).and_return(cart)
  end

  describe 'POST #create' do
    context 'when the book is out of stock' do
      let(:book) { create(:book, stock_quantity: 0) }

      it 'redirects to the cart with an alert' do
        post :create, params: { cart_item: { book_id: book.id, quantity: 1 } }
        expect(response).to redirect_to(cart)
        expect(flash[:alert]).to eq('Book is out of stock.')
      end
    end

    context 'when the requested quantity is more than available stock' do
      it 'adds only available quantity to the cart and redirects with a notice' do
        post :create, params: { cart_item: { book_id: book.id, quantity: 6 } }
        expect(response).to redirect_to(cart)
        expect(flash[:notice]).to eq('Only 5 out of 6 books were added to the cart due to limited stock.')
        expect(cart.cart_items.find_by(book_id: book.id).quantity).to eq(5)
      end
    end

    context 'when the requested quantity is within available stock' do
      it 'adds the requested quantity to the cart and redirects with a notice' do
        post :create, params: { cart_item: { book_id: book.id, quantity: 2 } }
        expect(response).to redirect_to(cart)
        expect(flash[:notice]).to eq('Book was successfully added to cart.')
        expect(cart.cart_items.find_by(book_id: book.id).quantity).to eq(2)
      end
    end

    context 'when unable to save cart item' do
      before do
        allow_any_instance_of(CartItem).to receive(:save).and_return(false)
      end

      it 'redirects to the cart with an alert' do
        post :create, params: { cart_item: { book_id: book.id, quantity: 1 } }
        expect(response).to redirect_to(cart)
        expect(flash[:alert]).to eq('Unable to add book to cart.')
      end
    end
  end

  describe 'GET #edit' do
    it 'assigns the requested cart item to @cart_item' do
      get :edit, params: { id: cart_item.id }
      expect(assigns(:cart_item)).to eq(cart_item)
    end
  end

  describe 'PATCH #update' do
    context 'with valid parameters' do
      it 'updates the cart item and redirects with a notice' do
        patch :update, params: { id: cart_item.id, cart_item: { quantity: 3 } }
        expect(response).to redirect_to(cart)
        expect(flash[:notice]).to eq('Cart item was successfully updated.')
        expect(cart_item.reload.quantity).to eq(3)
      end
    end

    context 'with invalid parameters' do
      before do
        allow_any_instance_of(CartItem).to receive(:update).and_return(false)
      end

      it 'redirects to the cart with an alert' do
        patch :update, params: { id: cart_item.id, cart_item: { quantity: 0 } }
        expect(response).to redirect_to(cart)
        expect(flash[:alert]).to eq('Unable to update cart item.')
      end
    end
  end

  describe 'DELETE #destroy' do
    it 'removes the cart item and redirects with a notice' do
      delete :destroy, params: { id: cart_item.id }
      expect(response).to redirect_to(cart)
      expect(flash[:notice]).to eq('Cart item was successfully removed.')
      expect(cart.cart_items.find_by(id: cart_item.id)).to be_nil
    end
  end
end
