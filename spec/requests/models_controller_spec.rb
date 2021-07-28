# frozen_string_literal: true

require 'rails_helper'

RSpec.describe ModelsController, type: :request do
  let(:manager) { create(:account, role: create(:role)) }
  let(:staff) { create(:account, role: create(:role, name: 'Staff')) }
  let(:model) { create(:model, name: 'iPhone X') }
  let(:model2) { create(:model, name: 'iPhone 7') }

  before(:each) do
    create(:inventory, model: model)
    create(:inventory, model: model)
  end

  # models#create
  describe 'POST /models/create' do
    subject { post models_create_path, params: params }
    let(:params) { build(:model, name: 'A new model').attributes }

    context 'when user logged in as manager' do
      before(:each) do
        sign_in manager
      end

      context 'with valid attributes' do
        it 'created successfully' do
          expect { subject }.to change(Model, :count).by(1)
        end

        it 'routed and rendered notice message successfully' do
          subject
          expect(response).to redirect_to(brands_path)
          follow_redirect!
          expect(response.body).to include('New model created successfully.')
        end
      end

      context 'with invalid attributes' do
        let(:params) { build(:model, name: nil).attributes }

        it 'created failed' do
          expect { subject }.to_not change(Model, :count)
        end

        it 'routed successfully' do
          subject
          expect(response).to redirect_to(brands_path)
        end
      end

      context 'with existed model attributes' do
        let(:params) { build(:model, name: model.name).attributes }

        it 'created failed' do
          expect { subject }.to_not change(Model, :count)
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

      it 'created failed' do
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

  # models#update
  describe 'PATCH /models/update' do
    subject { patch models_update_path, params: { id: model.id, new_name: new_name } }
    let(:new_name) { 'A new model name' }

    context 'when user logged in as manager' do
      before(:each) do
        sign_in manager
      end

      context 'with valid attributes' do
        it 'updated successfully' do
          subject
          model.reload
          expect(model.name).to eq('A new model name')
        end

        it 'routed and rendered notice message successfully' do
          subject
          expect(response).to redirect_to(brands_path)
          follow_redirect!
          expect(response.body).to include('Model name updated successfully.')
        end
      end

      context 'with invalid attributes' do
        let(:new_name) { nil }

        it 'updated failed' do
          subject
          model.reload
          expect(model.name).to eq('iPhone X')
        end

        it 'routed successfully' do
          subject
          expect(response).to redirect_to(brands_path)
        end
      end

      context 'with existed brand attributes' do
        let(:new_name) { model2.name }

        it 'updated failed' do
          subject
          model.reload
          expect(model.name).to eq('iPhone X')
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
        model.reload
        expect(model.name).to_not eq('A new model name')
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

  # models#destroy
  describe 'DELETE /models/:id' do
    subject { delete model_path(model.id) }

    context 'when user logged in as manager' do
      before(:each) do
        sign_in manager
      end

      it 'deleted successfully' do
        expect { subject }.to change(Model, :count).by(-1)
      end
      it 'deleted dependent inventories successfully' do
        expect { subject }.to change(Inventory, :count).to(0)
      end

      it 'routed and rendered notice message successfully' do
        subject
        expect(response).to redirect_to(brands_path)
        follow_redirect!
        expect(response.body).to include('Model deleted successfully.')
      end
    end

    context 'when user logged in as staff' do
      before(:each) do
        sign_in staff
      end

      it 'deleted failed' do
        expect { subject }.to_not change(Model, :count)
      end
      it 'deleted dependent inventories failed' do
        expect { subject }.to_not change(Inventory, :count)
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
