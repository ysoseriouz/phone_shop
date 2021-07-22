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
    context 'when user signed in' do
      before(:each) do
        sign_in create(:account)
      end

      it 'successfully render new inventory page' do
        get new_inventory_path
        expect(response).to render_template(:new)
      end

      it 'successfully initialize a new Inventory' do
        get new_inventory_path
        expect(assigns(:inventory)).to be_a_new(Inventory)
      end
    end

    context 'when user not signed in' do
      it 'redirect to log-in page' do
        get new_inventory_path
        expect(response).to redirect_to(new_account_session_path)
      end
    end
  end

  # inventories#create
  describe 'POST /inventories' do
    context 'when user signed in' do
      before(:each) do
        sign_in create(:account)
      end

      context 'valid attributes' do
        it 'created successfully' do
          post inventories_path, params: { inventory: build(:inventory).attributes }
          expect(Inventory.count).to eq(6)
        end

        it 'routed successfully' do
          post inventories_path, params: { inventory: build(:inventory).attributes }

          expect(response).to redirect_to(edit_inventory_path(assigns(:inventory)))
          follow_redirect!
          expect(response).to render_template(:edit)
        end
      end

      context 'invalid attributes' do
        it 'response status unprocessable_entity (422)' do
          post inventories_path, params: { inventory: build(:inventory, model_id: nil).attributes }
          expect(response).to have_http_status(422)
        end

        it 're-render new inventory page' do
          post inventories_path, params: { inventory: build(:inventory, model_id: nil).attributes }
          expect(response).to render_template(:new)
        end
      end
    end

    context 'when user not signed in' do
      it 'redirect to log-in page' do
        post inventories_path, params: { inventory: build(:inventory).attributes }
        expect(response).to redirect_to(new_account_session_path)
      end
    end
  end

  # inventories#edit
  describe 'GET /inventories/:id/edit' do
    let(:inventory) { Inventory.take }

    context 'when user signed in' do
      before(:each) do
        sign_in create(:account)
      end

      it 'successfully render edit inventory page' do
        get edit_inventory_path(inventory.id)
        expect(response).to render_template(:edit)
      end
    end

    context 'when user not signed in' do
      it 'redirect to log-in page' do
        get edit_inventory_path(inventory.id)
        expect(response).to redirect_to(new_account_session_path)
      end
    end
  end

  # inventories#update
  describe 'PATCH/PUT /inventories/:id' do
    let(:inventory) { Inventory.take }

    context 'when user signed in' do
      before(:each) do
        sign_in create(:account)
      end

      context 'valid attributes' do
        it 'updated successfully' do
          put inventory_path(inventory.id), params: { inventory: { memory_size: 1000 } }
          inventory.reload
          expect(inventory.memory_size).to eq(1000)
        end

        it 'redirect to edit page with updated information' do
          put inventory_path(inventory.id), params: { inventory: { memory_size: 1000 } }
          expect(response).to redirect_to(edit_inventory_path(assigns(:inventory)))
        end
      end

      context 'invalid attributes' do
        it 'updated failed and re-render' do
          put inventory_path(inventory.id), params: { inventory: { memory_size: nil, color: 'not a color' } }
          inventory.reload
          expect(inventory.color).to_not eq('not a color')
        end

        it 'response status unprocessable_entity (422)' do
          put inventory_path(inventory.id), params: { inventory: { memory_size: nil, color: 'not a color' } }
          inventory.reload
          expect(response).to have_http_status(422)
        end

        it 're-render edit inventory page' do
          put inventory_path(inventory.id), params: { inventory: { memory_size: nil, color: 'not a color' } }
          inventory.reload
          expect(response).to render_template(:edit)
        end
      end
    end

    context 'when user not signed in' do
      it 'redirect to log-in page' do
        put inventory_path(inventory.id), params: { inventory: { memory_size: 1000 } }
        expect(response).to redirect_to(new_account_session_path)
      end
    end
  end

  # inventories#destroy
  describe 'DELETE /inventories/:id' do
    let(:inventory) { Inventory.take }

    context 'when user signed in' do
      before(:each) do
        sign_in create(:account)
      end

      context 'valid existing inventory' do
        it 'deleted successfully' do
          delete inventory_path(inventory.id)
          expect(Inventory.count).to eq(4)
        end

        it 'routed successfully' do
          delete inventory_path(inventory.id)
          expect(response).to redirect_to(inventories_path)
          follow_redirect!
          expect(response).to render_template(:index)
        end
      end
    end

    context 'when user not signed in' do
      it 'redirect to log-in page' do
        delete inventory_path(inventory.id)
        expect(response).to redirect_to(new_account_session_path)
      end
    end
  end
end
