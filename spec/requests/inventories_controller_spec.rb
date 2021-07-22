require 'rails_helper'

RSpec.describe InventoriesController, type: :request do
  def seed_data
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

  let(:manager) { create(:account, role: create(:role)) }
  let(:search_params) { { color: 'black', status: :inactive } }

  before(:each) { seed_data }

  # inventories#index
  describe 'GET /inventories' do
    context 'when user signed in' do
      before(:each) do
        sign_in manager
      end

      it 'response successfully with user name' do
        get inventories_path

        expect(response).to render_template(:index)
        expect(response.body).to include('Test User')
        expect(assigns(:num_records)).to eq(5)
      end

      it 'is able to search' do
        get inventories_path, params: search_params

        expect(assigns(:num_records)).to eq(1)
      end
    end

    context 'when user not signed in' do
      it 'response successfully without user name' do
        get inventories_path

        expect(response).to render_template(:index)
        expect(response.body).to_not include('Test User')
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
        sign_in manager
      end

      it 'response successfully' do
        get new_inventory_path
        
        expect(response).to render_template(:new)
        expect(assigns(:inventory)).to be_a_new(Inventory)
      end
    end

    context 'when user not signed in' do
      it 'response failed' do
        get new_inventory_path

        expect(response).to redirect_to(new_account_session_path)
      end
    end
  end

  # inventories#create
  describe 'POST /inventories' do
    context 'when user signed in' do
      before(:each) do
        sign_in manager
      end

      context 'valid attributes' do
        it 'created successfully' do
          post inventories_path, params: { inventory: build(:inventory).attributes }

          expect(response).to redirect_to(edit_inventory_path(assigns(:inventory)))
          follow_redirect!
          expect(response).to render_template(:edit)
        end
      end

      context 'invalid attributes' do
        it 'created failed' do
          post inventories_path, params: { inventory: build(:inventory, model_id: nil).attributes }

          expect(response).to have_http_status(422)
          expect(response).to render_template(:new)
        end
      end
    end

    context 'when user not signed in' do
      it 'is not able to create' do
        post inventories_path, params: { inventory: build(:inventory).attributes }

        expect(response).to redirect_to(new_account_session_path)
      end
    end
  end

  # inventories#edit
  describe 'GET /inventories/:id/edit' do
    let(:inventory) {Inventory.take}

    context 'when user signed in' do
      before(:each) do
        sign_in manager
      end

      it 'is able to edit' do
        get edit_inventory_path(inventory.id)

        expect(response).to render_template(:edit)
      end
    end

    context 'when user not signed in' do
      it 'is not able to create' do
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
        sign_in manager
      end

      context 'valid attributes' do
        it 'updated successfully' do
          put inventory_path(inventory.id), params: { inventory: { memory_size: 1000 } }
          inventory.reload
  
          expect(inventory.memory_size).to eq(1000)
          expect(response).to redirect_to(edit_inventory_path(assigns(:inventory)))
        end
      end

      context 'invalid attributes' do
        it 'updated failed' do
          put inventory_path(inventory.id), params: { inventory: { memory_size: nil, color: 'not a color' } }
          inventory.reload
  
          expect(inventory.color).to_not eq('not a color')
          expect(response).to have_http_status(422)
          expect(response).to render_template(:edit)
        end
      end
    end

    context 'when user not signed in' do
      it 'is not able to update' do
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
        sign_in manager
      end

      context 'valid existing inventory' do
        it 'deleted successfully' do
          delete inventory_path(inventory.id)
  
          expect(response).to redirect_to(inventories_path)
          follow_redirect!
          expect(response).to render_template(:index)
          expect(assigns(:num_records)).to eq(4)
        end
      end
    end

    context 'when user not signed in' do
      it 'is not able to update' do
        delete inventory_path(inventory.id)

        expect(response).to redirect_to(new_account_session_path)
      end
    end
  end

end
