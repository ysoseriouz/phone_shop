# frozen_string_literal: true

require 'rails_helper'

RSpec.describe BrandsController, type: :request do
  let(:manager) { create(:account, role: create(:role)) }
  let(:staff) { create(:account, role: create(:role, name: 'Staff')) }

  before(:each) do
    @brand1 = create(:brand)
    @brand2 = create(:brand, name: 'Samsung')
    create(:model, brand: @brand1)
    create(:model, name: 'iPhone 7', brand: @brand1)
    create(:model, name: 'Galaxy Note 10', brand: @brand2)
  end

  # brands#index
  describe 'GET /brands' do
    shared_examples 'render index successfully' do
      it 'render index page' do
        get brands_path
        expect(response).to render_template(:index)
      end

      it 'render all brands' do
        get brands_path
        expect(assigns(:brands).count).to eq(2)
      end
    end

    context 'when user logged in as manager' do
      before(:each) do
        sign_in manager
      end

      include_examples 'render index successfully'
    end

    context 'when user logged in as staff' do
      before(:each) do
        sign_in staff
      end

      include_examples 'render index successfully'
    end

    context 'when user logged out' do
      it 'redirect to log-in page' do
        get brands_path
        expect(response).to redirect_to(new_account_session_path)
      end
    end
  end

  # brands#create
  describe 'POST /brands/create' do
    context 'when user logged in as manager' do
      before(:each) do
        sign_in manager
      end

      context 'with valid attributes' do
        it 'created successfully' do
          post brands_create_path, params: { name: 'A new brand' }
          expect(Brand.count).to eq(3)
        end

        it 'routed and rendered notice message successfully' do
          post brands_create_path, params: { name: 'A new brand' }
          expect(response).to redirect_to(brands_path)
          follow_redirect!
          expect(response.body).to include('New brand created successfully.')
        end
      end

      context 'with invalid attributes' do
        it 'created failed' do
          post brands_create_path, params: { name: nil }
          expect(Brand.count).to eq(2)
        end

        it 'routed successfully' do
          post brands_create_path, params: { name: nil }
          expect(response).to redirect_to(brands_path)
        end
      end

      context 'with existed brand attributes' do
        it 'created failed' do
          post brands_create_path, params: attributes_for(:brand)
          expect(Brand.count).to eq(2)
        end

        it 'routed successfully' do
          post brands_create_path, params: attributes_for(:brand)
          expect(response).to redirect_to(brands_path)
        end
      end
    end

    context 'when user logged in as staff' do
      before(:each) do
        sign_in staff
      end

      it 'created failed' do
        post brands_create_path, params: { name: 'A new brand' }
        expect(Brand.count).to eq(2)
      end

      it 'render unauthorized alert message' do
        post brands_create_path, params: { name: 'A new brand' }
        expect(response).to redirect_to(brands_path)
        follow_redirect!
        expect(response.body).to include('You are not authorized.')
      end
    end

    context 'when user logged out' do
      it 'redirect to log-in page' do
        post brands_create_path, params: { name: 'A new brand' }
        expect(response).to redirect_to(new_account_session_path)
      end
    end
  end

  # brands#update
  describe 'PATCH /brands/update' do
    context 'when user logged in as manager' do
      before(:each) do
        sign_in manager
      end

      context 'with valid attributes' do
        it 'updated successfully' do
          patch brands_update_path, params: { id: @brand2.id, new_name: 'A new brand name' }
          @brand2.reload
          expect(@brand2.name).to eq('A new brand name')
        end

        it 'routed and rendered notice message successfully' do
          patch brands_update_path, params: { id: @brand2.id, new_name: 'A new brand name' }
          expect(response).to redirect_to(brands_path)
          follow_redirect!
          expect(response.body).to include('Brand name updated successfully.')
        end
      end

      context 'with invalid attributes' do
        it 'updated failed' do
          patch brands_update_path, params: { id: @brand2.id, new_name: nil }
          @brand2.reload
          expect(@brand2.name).to eq('Samsung')
        end

        it 'routed successfully' do
          patch brands_update_path, params: { id: @brand2.id, new_name: nil }
          expect(response).to redirect_to(brands_path)
        end
      end

      context 'with existed brand attributes' do
        it 'updated failed' do
          patch brands_update_path, params: { id: @brand2.id, new_name: @brand1.name }
          @brand2.reload
          expect(@brand2.name).to eq('Samsung')
        end

        it 'routed successfully' do
          patch brands_update_path, params: { id: @brand2.id, new_name: @brand1.name }
          expect(response).to redirect_to(brands_path)
        end
      end
    end

    context 'when user logged in as staff' do
      before(:each) do
        sign_in staff
      end

      it 'updated failed' do
        patch brands_update_path, params: { id: @brand2.id, new_name: 'A new brand name' }
        @brand2.reload
        expect(@brand2.name).to eq('Samsung')
      end

      it 'render unauthorized alert message' do
        patch brands_update_path, params: { id: @brand2.id, new_name: 'A new brand name' }
        expect(response).to redirect_to(brands_path)
        follow_redirect!
        expect(response.body).to include('You are not authorized.')
      end
    end

    context 'when user logged out' do
      it 'redirect to log-in page' do
        patch brands_update_path, params: { id: @brand2.id, new_name: 'A new brand name' }
        expect(response).to redirect_to(new_account_session_path)
      end
    end
  end

  # brands#destroy
  describe 'DELETE /brands/:id' do
    context 'when user logged in as manager' do
      before(:each) do
        sign_in manager
      end

      it 'deleted successfully' do
        delete brand_path(@brand1.id)
        expect(Brand.count).to eq(1)
        expect(Model.count).to eq(1)
      end

      it 'routed and rendered notice message successfully' do
        delete brand_path(@brand1.id)
        expect(response).to redirect_to(brands_path)
        follow_redirect!
        expect(response.body).to include('Brand deleted successfully.')
      end
    end

    context 'when user logged in as staff' do
      before(:each) do
        sign_in staff
      end

      it 'deleted failed' do
        delete brand_path(@brand1.id)
        expect(Brand.count).to eq(2)
        expect(Model.count).to eq(3)
      end

      it 'render unauthorized alert message' do
        delete brand_path(@brand1.id)
        expect(response).to redirect_to(brands_path)
        follow_redirect!
        expect(response.body).to include('You are not authorized.')
      end
    end

    context 'when user logged out' do
      it 'redirect to log-in page' do
        delete brand_path(@brand1.id)
        expect(response).to redirect_to(new_account_session_path)
      end
    end
  end
end
