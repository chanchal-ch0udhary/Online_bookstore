require 'rails_helper'

RSpec.describe BooksController, type: :controller do
  let(:admin) { create(:admin) }
  let(:user) { create(:user) }
  let(:book) { create(:book) }

  describe 'GET #index' do
    it 'returns a successful response' do
      get :index
      expect(response).to be_successful
    end

    it 'assigns @books' do
      book
      get :index
      expect(assigns(:books)).to eq([book])
    end
  end

  describe 'GET #show' do
    it 'returns a successful response' do
      get :show, params: { id: book.id }
      expect(response).to be_successful
    end

    it 'assigns @book' do
      get :show, params: { id: book.id }
      expect(assigns(:book)).to eq(book)
    end
  end

  describe 'GET #new' do
    context 'when user is an admin' do
      before { sign_in admin }

      it 'returns a successful response' do
        get :new
        expect(response).to be_successful
      end
    end

    context 'when user is not an admin' do
      before { sign_in user }

      it 'redirects to the root path with an alert' do
        get :new
        expect(response).to redirect_to(root_path)
        expect(flash[:alert]).to eq('You are not authorized to perform this action.')
      end
    end
  end

  describe 'POST #create' do
    context 'when user is an admin' do
      before { sign_in admin }

      context 'with valid parameters' do
        it 'creates a new book' do
          expect {
            post :create, params: { book: attributes_for(:book) }
          }.to change(Book, :count).by(1)
        end

        it 'redirects to the created book' do
          post :create, params: { book: attributes_for(:book) }
          expect(response).to redirect_to(Book.last)
          expect(flash[:notice]).to eq('Book was successfully created.')
        end
      end

      context 'with invalid parameters' do
        it 'does not create a new book' do
          expect {
            post :create, params: { book: attributes_for(:book, title: nil) }
          }.to_not change(Book, :count)
        end

        it 'renders the new template' do
          post :create, params: { book: attributes_for(:book, title: nil) }
          expect(response).to render_template(:new)
        end
      end
    end

    context 'when user is not an admin' do
      before { sign_in user }

      it 'redirects to the root path with an alert' do
        post :create, params: { book: attributes_for(:book) }
        expect(response).to redirect_to(root_path)
        expect(flash[:alert]).to eq('You are not authorized to perform this action.')
      end
    end
  end

  describe 'GET #edit' do
    context 'when user is an admin' do
      before { sign_in admin }

      it 'returns a successful response' do
        get :edit, params: { id: book.id }
        expect(response).to be_successful
      end
    end

    context 'when user is not an admin' do
      before { sign_in user }

      it 'redirects to the root path with an alert' do
        get :edit, params: { id: book.id }
        expect(response).to redirect_to(root_path)
        expect(flash[:alert]).to eq('You are not authorized to perform this action.')
      end
    end
  end

  describe 'PATCH #update' do
    context 'when user is an admin' do
      before { sign_in admin }

      context 'with valid parameters' do
        it 'updates the book' do
          patch :update, params: { id: book.id, book: { title: 'Updated Title' } }
          book.reload
          expect(book.title).to eq('Updated Title')
        end

        it 'redirects to the book' do
          patch :update, params: { id: book.id, book: { title: 'Updated Title' } }
          expect(response).to redirect_to(book)
          expect(flash[:notice]).to eq('Book was successfully updated.')
        end
      end

      context 'with invalid parameters' do
        it 'does not update the book' do
          patch :update, params: { id: book.id, book: { title: nil } }
          book.reload
          expect(book.title).to_not be_nil
        end

        it 'renders the edit template' do
          patch :update, params: { id: book.id, book: { title: nil } }
          expect(response).to render_template(:edit)
        end
      end
    end

    context 'when user is not an admin' do
      before { sign_in user }

      it 'redirects to the root path with an alert' do
        patch :update, params: { id: book.id, book: { title: 'Updated Title' } }
        expect(response).to redirect_to(root_path)
        expect(flash[:alert]).to eq('You are not authorized to perform this action.')
      end
    end
  end

  describe 'DELETE #destroy' do
    context 'when user is an admin' do
      before { sign_in admin }

      it 'destroys the book' do
        book
        expect {
          delete :destroy, params: { id: book.id }
        }.to change(Book, :count).by(-1)
      end

      it 'redirects to the books index with a notice' do
        delete :destroy, params: { id: book.id }
        expect(response).to redirect_to(books_url)
        expect(flash[:notice]).to eq('Book was successfully destroyed.')
      end
    end

    context 'when user is not an admin' do
      before { sign_in user }

      it 'redirects to the root path with an alert' do
        delete :destroy, params: { id: book.id }
        expect(response).to redirect_to(root_path)
        expect(flash[:alert]).to eq('You are not authorized to perform this action.')
      end
    end
  end
end
