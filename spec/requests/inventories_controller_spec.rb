# frozen_string_literal: true

require 'rails_helper'

RSpec.describe InventoriesController, type: :request do
  before(:each) do
    brand1 = create(:brand)
    brand2 = create(:brand, name: 'Samsung')
    model1 = create(:model, brand: brand1)
    model2 = create(:model, name: 'iPhone 7', brand: brand1)
    model3 = create(:model, name: 'Galaxy Note 10', brand: brand2)

    create(:inventory, model: model1, memory_size: 10, manufactoring_year: 2020, price: 9_000_000)
    create(:inventory, model: model1, memory_size: 32, manufactoring_year: 2020,
                       price: 10_000_000, os_version: 'iOS 14', color: 'green')
    create(:inventory, model: model2, memory_size: 200, manufactoring_year: 2014,
                       price: 15_000_000, os_version: 'Android 5', color: 'black', status: :inactive)
    create(:inventory, model: model3, memory_size: 300, manufactoring_year: 2021,
                       price: 20_000_000, os_version: 'Android 5', color: 'Green', status: :inactive)
    create(:inventory, model: model3, memory_size: 256, manufactoring_year: 2019,
                       price: 30_000_000, os_version: 'Android 11', color: 'BLACK', status: :sold)
  end

  # inventories#index
  describe 'GET /inventories' do
    let(:search_params) { { color: 'black', status: :inactive } }

    context 'when user signed in' do
      before(:each) do
        sign_in create(:account)
      end

      it 'successfully render index page' do
        get inventories_path
        expect(response).to render_template(:index)
      end

      it "successfully render user's name" do
        get inventories_path
        expect(response.body).to include('Test User')
      end

      it 'display all inventory records' do
        get inventories_path
        expect(assigns(:num_records)).to eq(5)
      end

      it 'is able to search' do
        get inventories_path, params: search_params
        expect(assigns(:num_records)).to eq(1)
      end
    end

    context 'when user not signed in' do
      it 'successfully render index page' do
        get inventories_path
        expect(response).to render_template(:index)
      end

      it "not render user's name" do
        get inventories_path
        expect(response.body).to_not include('Test User')
      end

      it 'display all inventory records' do
        get inventories_path
        expect(assigns(:num_records)).to eq(5)
      end

      it 'is able to search' do
        get inventories_path, params: search_params
        expect(assigns(:num_records)).to eq(1)
      end
    end
  end

  # inventories#new
  describe 'GET /inventories/new' do
    subject { get new_inventory_path }

    context 'when user signed in' do
      before(:each) do
        sign_in create(:account)
      end

      it 'successfully render new inventory page' do
        subject
        expect(response).to render_template(:new)
      end

      it 'successfully initialize a new Inventory' do
        subject
        expect(assigns(:inventory)).to be_a_new(Inventory)
      end
    end

    context 'when user not signed in' do
      it 'redirect to log-in page' do
        subject
        expect(response).to redirect_to(new_account_session_path)
      end
    end
  end

  # inventories#create
  describe 'POST /inventories' do
    subject { post inventories_path, params: params }
    let(:params) { { inventory: build(:inventory).attributes } }

    context 'when user signed in' do
      before(:each) do
        sign_in create(:account)
      end

      context 'valid attributes' do
        let(:params) { { inventory: build(:inventory).attributes } }

        it 'created successfully' do
          expect { subject }.to change(Inventory, :count).by(1)
        end

        it 'routed successfully' do
          subject
          expect(response).to redirect_to(edit_inventory_path(assigns(:inventory)))
          follow_redirect!
          expect(response).to render_template(:edit)
        end
      end

      context 'invalid attributes' do
        let(:params) { { inventory: build(:inventory, model_id: nil).attributes } }

        it 'response status unprocessable_entity (422)' do
          subject
          expect(response).to have_http_status(422)
        end

        it 're-render new inventory page' do
          subject
          expect(response).to render_template(:new)
        end
      end
    end

    context 'when user not signed in' do
      it 'redirect to log-in page' do
        subject
        expect(response).to redirect_to(new_account_session_path)
      end
    end
  end

  # inventories#edit
  describe 'GET /inventories/:id/edit' do
    subject { get edit_inventory_path(Inventory.take.id) }

    context 'when user signed in' do
      before(:each) do
        sign_in create(:account)
      end

      it 'successfully render edit inventory page' do
        subject
        expect(response).to render_template(:edit)
      end
    end

    context 'when user not signed in' do
      it 'redirect to log-in page' do
        subject
        expect(response).to redirect_to(new_account_session_path)
      end
    end
  end

  # inventories#update
  describe 'PATCH/PUT /inventories/:id' do
    subject { put inventory_path(inventory.id), params: params }
    let(:inventory) { Inventory.take }
    let(:params) { { inventory: { memory_size: 1000 } } }

    context 'when user signed in' do
      before(:each) do
        sign_in create(:account)
      end

      context 'valid attributes' do
        it 'updated successfully' do
          subject
          inventory.reload
          expect(inventory.memory_size).to eq(1000)
        end

        it 'redirect to edit page with updated information' do
          subject
          expect(response).to redirect_to(edit_inventory_path(assigns(:inventory)))
        end
      end

      context 'invalid attributes' do
        let(:params) { { inventory: { memory_size: nil, color: 'not a color' } } }

        it 'updated failed and re-render' do
          subject
          inventory.reload
          expect(inventory.color).to_not eq('not a color')
        end

        it 'response status unprocessable_entity (422)' do
          subject
          inventory.reload
          expect(response).to have_http_status(422)
        end

        it 're-render edit inventory page' do
          subject
          inventory.reload
          expect(response).to render_template(:edit)
        end
      end
    end

    context 'when user not signed in' do
      it 'redirect to log-in page' do
        subject
        expect(response).to redirect_to(new_account_session_path)
      end
    end
  end

  # inventories#destroy
  describe 'DELETE /inventories/:id' do
    subject { delete inventory_path(Inventory.take.id) }

    context 'when user signed in' do
      before(:each) do
        sign_in create(:account)
      end

      context 'valid existing inventory' do
        it 'deleted successfully' do
          expect { subject }.to change(Inventory, :count).by(-1)
        end

        it 'routed successfully' do
          subject
          expect(response).to redirect_to(inventories_path)
          follow_redirect!
          expect(response).to render_template(:index)
        end
      end
    end

    context 'when user not signed in' do
      it 'redirect to log-in page' do
        subject
        expect(response).to redirect_to(new_account_session_path)
      end
    end
  end
end
