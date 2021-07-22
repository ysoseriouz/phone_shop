# frozen_string_literal: true

require 'rails_helper'

RSpec.describe Inventory, type: :model do
  describe '.new' do
    let(:inventory) do
      model = create(:model, brand: create(:brand))
      build(:inventory, model: model, memory_size: 256, manufactoring_year: 2020,
                        os_version: 'iOS 14', color: 'black', price: 10_000.50,
                        original_price: 9000.50, status: :active)
    end

    it 'is valid with valid attributes' do
      expect(inventory).to be_valid
    end

    it 'is not valid without belonging to a Model' do
      inventory.model_id = nil
      expect(inventory).to_not be_valid
    end

    it 'is not valid without memory_size' do
      inventory.memory_size = nil
      expect(inventory).to_not be_valid
    end

    it 'is not valid without manufactoring_year' do
      inventory.manufactoring_year = nil
      expect(inventory).to_not be_valid
    end

    it 'is not valid without os_version' do
      inventory.os_version = nil
      expect(inventory).to_not be_valid
    end

    it 'is not valid without color' do
      inventory.color = nil
      expect(inventory).to_not be_valid
    end

    it 'is not valid without price' do
      inventory.price = nil
      expect(inventory).to_not be_valid
    end

    it 'is not valid if model is not existed' do
      inventory.model_id = 5
      expect(inventory).to_not be_valid
    end

    context 'with memory_size' do
      it 'invalid if negative' do
        inventory.memory_size = -45
        expect(inventory).to_not be_valid
      end

      it 'invalid if not integer' do
        inventory.memory_size = 18.5
        expect(inventory).to_not be_valid
      end
    end

    context 'with manufactoring_year' do
      it 'invalid if negative' do
        inventory.manufactoring_year = -45
        expect(inventory).to_not be_valid
      end

      it 'invalid if not integer' do
        inventory.manufactoring_year = 25.5
        expect(inventory).to_not be_valid
      end

      it 'invalid if year in the future' do
        inventory.manufactoring_year = Time.zone.now.year + 1
        expect(inventory).to_not be_valid
      end
    end

    it 'is not valid if price is negative price' do
      inventory.price = -1
      expect(inventory).to_not be_valid
    end
  end

  describe '.scope' do
    before(:all) do
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

    context 'when records found' do
      it 'by brand' do
        brand = Brand.find_by(name: 'Apple')
        inventories = Inventory.by_brand_id(brand.id)
        expect(inventories.count).to eq(3)
      end

      it 'by model' do
        model = Model.find_by(name: 'iPhone X')
        inventories = Inventory.by_model_id(model.id)
        expect(inventories.count).to eq(2)
      end

      it 'by manufactoring_year lower bound' do
        inventories = Inventory.by_manufactoring_year_lower(2020)
        expect(inventories.count).to eq(3)
      end

      it 'by manufactoring_year upper bound' do
        inventories = Inventory.by_manufactoring_year_upper(2019)
        expect(inventories.count).to eq(2)
      end

      context 'when memory_size range' do
        it 'Under 16GB' do
          inventories = Inventory.by_memory_size('Under 16GB')
          expect(inventories.count).to eq(1)
        end

        it 'From 16GB to 64GB' do
          inventories = Inventory.by_memory_size('From 16GB to 64GB')
          expect(inventories.count).to eq(1)
        end

        it 'From 64GB to 256GB' do
          inventories = Inventory.by_memory_size('From 64GB to 256GB')
          expect(inventories.count).to eq(2)
        end

        it 'Over 256GB' do
          inventories = Inventory.by_memory_size('Over 256GB')
          expect(inventories.count).to eq(2)
        end
      end

      context 'when price range' do
        it 'Under 10 million VND' do
          inventories = Inventory.by_price('Under 10 million VND')
          expect(inventories.count).to eq(2)
        end

        it 'From 10 to 15 million VND' do
          inventories = Inventory.by_price('From 10 to 15 million VND')
          expect(inventories.count).to eq(2)
        end

        it 'From 15 to 20 million VND' do
          inventories = Inventory.by_price('From 15 to 20 million VND')
          expect(inventories.count).to eq(2)
        end

        it 'From 20 to 30 million VND' do
          inventories = Inventory.by_price('From 20 to 30 million VND')
          expect(inventories.count).to eq(2)
        end

        it 'Over 30 million VND' do
          inventories = Inventory.by_price('Over 30 million VND')
          expect(inventories.count).to eq(1)
        end
      end

      context 'when status' do
        it 'active' do
          inventories = Inventory.by_status(:active)
          expect(inventories.count).to eq(2)
        end

        it 'inactive' do
          inventories = Inventory.by_status(:inactive)
          expect(inventories.count).to eq(2)
        end

        it 'sold' do
          inventories = Inventory.by_status(:sold)
          expect(inventories.count).to eq(1)
        end
      end

      it 'by os_version' do
        inventories = Inventory.by_os_version('iOS 14')
        expect(inventories.count).to eq(2)
      end

      it 'by color' do
        inventories = Inventory.by_color('black')
        expect(inventories.count).to eq(3)
      end
    end

    context 'when records not found' do
      it 'by brand' do
        inventories = Inventory.by_brand_id(5)
        expect(inventories.count).to eq(0)
      end

      it 'by model' do
        inventories = Inventory.by_model_id(5)
        expect(inventories.count).to eq(0)
      end

      it 'by os_version' do
        inventories = Inventory.by_os_version('Android5')
        expect(inventories.count).to eq(0)
      end

      it 'by color' do
        inventories = Inventory.by_color('greeny')
        expect(inventories.count).to eq(0)
      end
    end
  end
end
