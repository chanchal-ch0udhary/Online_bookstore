# spec/controllers/carts_controller_spec.rb
require 'rails_helper'

RSpec.describe CartsController, type: :controller do
  let(:user) { create(:user) }
  let(:cart) { create(:cart, user: user) }
  let!(:book) { create(:book, stock_quantity: 10) }
  let!(:cart_item) { create(:cart_item, cart: cart, book: book, quantity: 2) }

  before do
    sign_in user
    allow(controller).to receive(:current_user).and_return(user)
  end

  describe "GET #show" do
    it "returns a successful response" do
      get :show, params: { id: cart.id }
      expect(response).to be_successful
    end

    it "assigns the user's cart to @cart" do
      get :show, params: { id: cart.id }
      expect(assigns(:cart)).to eq(cart)
    end
  end

  describe "GET #checkout" do
    it "returns a successful response" do
      get :checkout
      expect(response).to be_successful
    end

    it "assigns the user's cart to @cart" do
      get :checkout
      expect(assigns(:cart)).to eq(cart)
    end
  end

  describe "POST #complete_order" do
    it "reduces the stock quantity of each book in the cart" do
      post :complete_order
      book.reload
      expect(book.stock_quantity).to eq(8)
    end

    it "destroys all cart items" do
      expect {
        post :complete_order
      }.to change(CartItem, :count).by(-1)
    end

    it "redirects to the root path with a notice" do
      post :complete_order
      expect(response).to redirect_to(root_path)
      expect(flash[:notice]).to eq('Order completed successfully')
    end
  end
end
