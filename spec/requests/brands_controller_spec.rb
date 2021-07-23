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
      subject { get brands_path }
      it 'render index page' do
        subject
        expect(response).to render_template(:index)
      end

      it 'render all brands' do
        subject
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
    subject { post brands_create_path, params: params }

    context 'when user logged in as manager' do
      before(:each) do
        sign_in manager
      end

      context 'with valid attributes' do
        let(:params) { { name: 'A new brand' } }

        it 'routed and rendered notice message successfully' do
          subject
          expect(response).to redirect_to(brands_path)
          follow_redirect!
          expect(response.body).to include('New brand created successfully.')
        end

        it 'created successfully' do
          expect { subject }.to change(Brand, :count).by(1)
        end
      end

      context 'with invalid attributes' do
        let(:params) { { name: nil } }

        it 'created failed' do
          expect { subject }.to_not change(Brand, :count)
        end

        it 'routed successfully' do
          subject
          expect(response).to redirect_to(brands_path)
        end
      end

      context 'with existed brand attributes' do
        let(:params) { attributes_for(:brand) }

        it 'created failed' do
          expect { subject }.to_not change(Brand, :count)
        end

        it 'routed successfully' do
          subject
          expect(response).to redirect_to(brands_path)
        end
      end
    end

    context 'when user logged in as staff' do
      let(:params) { { name: 'A new brand' } }

      before(:each) do
        sign_in staff
      end

      it 'created failed' do
        expect { subject }.to_not change(Brand, :count)
      end

      it 'render unauthorized alert message' do
        subject
        expect(response).to redirect_to(brands_path)
        follow_redirect!
        expect(response.body).to include('You are not authorized.')
      end
    end

    context 'when user logged out' do
      let(:params) { { name: 'A new brand' } }

      it 'redirect to log-in page' do
        subject
        expect(response).to redirect_to(new_account_session_path)
      end
    end
  end

  # brands#update
  describe 'PATCH /brands/update' do
    subject { patch brands_update_path, params: { id: @brand2.id, new_name: new_name } }
    let(:new_name) { 'A new brand name' }

    context 'when user logged in as manager' do
      before(:each) do
        sign_in manager
      end

      context 'with valid attributes' do
        it 'updated successfully' do
          subject
          @brand2.reload
          expect(@brand2.name).to eq('A new brand name')
        end

        it 'routed and rendered notice message successfully' do
          subject
          expect(response).to redirect_to(brands_path)
          follow_redirect!
          expect(response.body).to include('Brand name updated successfully.')
        end
      end

      context 'with invalid attributes' do
        let(:new_name) {}

        it 'updated failed' do
          subject
          @brand2.reload
          expect(@brand2.name).to eq('Samsung')
        end

        it 'routed successfully' do
          subject
          expect(response).to redirect_to(brands_path)
        end
      end

      context 'with existed brand attributes' do
        let(:new_name) { @brand1.name }

        it 'updated failed' do
          subject
          @brand2.reload
          expect(@brand2.name).to eq('Samsung')
        end

        it 'routed successfully' do
          subject
          expect(response).to redirect_to(brands_path)
        end
      end
    end

    context 'when user logged in as staff' do
      before(:each) do
        sign_in staff
      end

      it 'updated failed' do
        subject
        @brand2.reload
        expect(@brand2.name).to eq('Samsung')
      end

      it 'render unauthorized alert message' do
        subject
        expect(response).to redirect_to(brands_path)
        follow_redirect!
        expect(response.body).to include('You are not authorized.')
      end
    end

    context 'when user logged out' do
      it 'redirect to log-in page' do
        subject
        expect(response).to redirect_to(new_account_session_path)
      end
    end
  end

  # brands#destroy
  describe 'DELETE /brands/:id' do
    subject { delete brand_path(@brand1.id) }
    context 'when user logged in as manager' do
      before(:each) do
        sign_in manager
      end

      it 'deleted successfully' do
        expect { subject }.to change(Brand, :count).by(-1)
      end

      it 'deleted dependent models successfully' do
        expect { subject }.to change(Model, :count).from(3).to(1)
      end

      it 'routed and rendered notice message successfully' do
        subject
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
        expect { subject }.to_not change(Brand, :count)
      end

      it 'deleted dependent models failed' do
        expect { subject }.to_not change(Model, :count)
      end

      it 'render unauthorized alert message' do
        subject
        expect(response).to redirect_to(brands_path)
        follow_redirect!
        expect(response.body).to include('You are not authorized.')
      end
    end

    context 'when user logged out' do
      it 'redirect to log-in page' do
        subject
        expect(response).to redirect_to(new_account_session_path)
      end
    end
  end
end
