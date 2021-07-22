# frozen_string_literal: true

require 'rails_helper'

RSpec.describe ModelsController, type: :request do
  let(:manager) { create(:account, role: create(:role)) }
  let(:staff) { create(:account, role: create(:role, name: 'Staff')) }

  before(:each) do
    @model = create(:model)
    @model2 = create(:model, name: 'iPhone 7')
    create(:inventory, model: @model)
    create(:inventory, model: @model)
  end

  # models#create
  describe 'POST /models/create' do
    context 'when user logged in as manager' do
      before(:each) do
        sign_in manager
      end

      context 'with valid attributes' do
        before(:each) do
          post models_create_path, params: build(:model, name: 'A new model').attributes
        end

        it 'created successfully' do
          expect(Model.count).to eq(3)
        end

        it 'routed and rendered notice message successfully' do
          expect(response).to redirect_to(brands_path)
          follow_redirect!
          expect(response.body).to include('New model created successfully.')
        end
      end

      context 'with invalid attributes' do
        before(:each) do
          post models_create_path, params: build(:model, name: nil).attributes
        end

        it 'created failed' do
          expect(Model.count).to eq(2)
        end

        it 'routed successfully' do
          expect(response).to redirect_to(brands_path)
        end
      end

      context 'with existed model attributes' do
        before(:each) do
          post models_create_path, params: build(:model, name: @model.name).attributes
        end

        it 'created failed' do
          expect(Model.count).to eq(2)
        end

        it 'routed successfully' do
          expect(response).to redirect_to(brands_path)
        end
      end
    end

    context 'when user logged in as staff' do
      before(:each) do
        sign_in staff
        post models_create_path, params: build(:model, name: 'A new model').attributes
      end

      it 'created failed' do
        expect(Model.count).to eq(2)
      end

      it 'render unauthorized alert message' do
        expect(response).to redirect_to(brands_path)
        follow_redirect!
        expect(response.body).to include('You are not authorized.')
      end
    end

    context 'when user logged out' do
      it 'redirect to log-in page' do
        post models_create_path, params: build(:model, name: 'A new model').attributes
        expect(response).to redirect_to(new_account_session_path)
      end
    end
  end

  # models#update
  describe 'PATCH /models/update' do
    context 'when user logged in as manager' do
      before(:each) do
        sign_in manager
      end

      context 'with valid attributes' do
        before(:each) do
          patch models_update_path, params: { id: @model.id, new_name: 'A new model name' }
        end

        it 'updated successfully' do
          @model.reload
          expect(@model.name).to eq('A new model name')
        end

        it 'routed and rendered notice message successfully' do
          expect(response).to redirect_to(brands_path)
          follow_redirect!
          expect(response.body).to include('Model name updated successfully.')
        end
      end

      context 'with invalid attributes' do
        before(:each) do
          patch models_update_path, params: { id: @model.id, new_name: nil }
        end

        it 'updated failed' do
          @model.reload
          expect(@model.name).to eq('iPhone X')
        end

        it 'routed successfully' do
          expect(response).to redirect_to(brands_path)
        end
      end

      context 'with existed brand attributes' do
        before(:each) do
          patch models_update_path, params: { id: @model.id, new_name: @model2.name }
        end

        it 'updated failed' do
          @model.reload
          expect(@model.name).to eq('iPhone X')
        end

        it 'routed successfully' do
          expect(response).to redirect_to(brands_path)
        end
      end
    end

    context 'when user logged in as staff' do
      before(:each) do
        sign_in staff
        patch models_update_path, params: { id: @model.id, new_name: 'A new model name' }
      end

      it 'updated failed' do
        @model.reload
        expect(@model.name).to_not eq('A new model name')
      end

      it 'render unauthorized alert message' do
        expect(response).to redirect_to(brands_path)
        follow_redirect!
        expect(response.body).to include('You are not authorized.')
      end
    end

    context 'when user logged out' do
      it 'redirect to log-in page' do
        patch models_update_path, params: { id: @model.id, new_name: 'A new model name' }
        expect(response).to redirect_to(new_account_session_path)
      end
    end
  end

  # models#destroy
  describe 'DELETE /models/:id' do
    context 'when user logged in as manager' do
      before(:each) do
        sign_in manager
        delete model_path(@model.id)
      end

      it 'deleted successfully' do
        expect(Model.count).to eq(1)
        expect(Inventory.count).to eq(0)
      end

      it 'routed and rendered notice message successfully' do
        expect(response).to redirect_to(brands_path)
        follow_redirect!
        expect(response.body).to include('Model deleted successfully.')
      end
    end

    context 'when user logged in as staff' do
      before(:each) do
        sign_in staff
        delete model_path(@model.id)
      end

      it 'deleted failed' do
        expect(Model.count).to eq(2)
        expect(Inventory.count).to eq(2)
      end

      it 'render unauthorized alert message' do
        expect(response).to redirect_to(brands_path)
        follow_redirect!
        expect(response.body).to include('You are not authorized.')
      end
    end

    context 'when user logged out' do
      it 'redirect to log-in page' do
        delete model_path(@model.id)
        expect(response).to redirect_to(new_account_session_path)
      end
    end
  end
end
