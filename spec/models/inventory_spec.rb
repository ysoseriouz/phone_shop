# frozen_string_literal: true

require 'rails_helper'

RSpec.describe Inventory, type: :model do
  def seed_data       # rubocop:disable Metrics/MethodLength
    brand1 = Brand.create(name: 'Apple')
    brand2 = Brand.create(name: 'Samsung')
    model1 = Model.create(name: 'iPhone X', brand: brand1)
    model2 = Model.create(name: 'iPhone 7', brand: brand1)
    model3 = Model.create(name: 'Galaxy Note 10', brand: brand2)

    Inventory.create(
      model: model1, memory_size: 10, manufactoring_year: 2020,
      os_version: 'iOS 14', color: 'black', price: 9_000_000, status: :active
    )
    Inventory.create(
      model: model1, memory_size: 32, manufactoring_year: 2020,
      os_version: 'iOS 14', color: 'green', price: 10_000_000, status: :active
    )
    Inventory.create(
      model: model2, memory_size: 200, manufactoring_year: 2014,
      os_version: 'Android 5', color: 'black', price: 15_000_000, status: :inactive
    )
    Inventory.create(
      model: model3, memory_size: 300, manufactoring_year: 2021,
      os_version: 'Android 5', color: 'Green', price: 20_000_000, status: :inactive
    )
    Inventory.create(
      model: model3, memory_size: 256, manufactoring_year: 2019,
      os_version: 'Android 11', color: 'BLACK', price: 30_000_000, status: :sold
    )
  end

  describe '.new' do
    let(:brand) { Brand.create(name: 'Apple 2') }
    let(:model) { Model.create(name: 'iPhone 100', brand: brand) }
    let(:inventory) do
      Inventory.new(
        model: model, memory_size: 256, manufactoring_year: 2020,
        os_version: 'iOS 14', color: 'black', price: 10_000.50,
        original_price: 9000.50, status: :active, source: 'retailer',
        description: 'Test creating new inventory'
      )
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
    it 'is not valid if memory_size is not a positive integer number' do
      inventory.memory_size = -45
      expect(inventory).to_not be_valid
      inventory.memory_size = 18.5
      expect(inventory).to_not be_valid
    end
    it 'is not valid if manufactoring_year is not a reasonable year (positive integer and <= current year)' do
      inventory.manufactoring_year = -45
      expect(inventory).to_not be_valid
      inventory.manufactoring_year = 25.5
      expect(inventory).to_not be_valid
      inventory.manufactoring_year = Time.zone.now.year + 1
      expect(inventory).to_not be_valid
    end
    it 'is not valid if price is negative price' do
      inventory.price = -1
      expect(inventory).to_not be_valid
    end
  end

  describe '.scope' do
    before(:all) do
      seed_data
    end

    after(:all) do
      Brand.destroy_all
      Model.destroy_all
    end

    context 'records found' do
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
      it 'by memory_size range' do
        inventories = Inventory.by_memory_size('Under 16GB')
        expect(inventories.count).to eq(1)
        inventories = Inventory.by_memory_size('From 16GB to 64GB')
        expect(inventories.count).to eq(1)
        inventories = Inventory.by_memory_size('From 64GB to 256GB')
        expect(inventories.count).to eq(2)
        inventories = Inventory.by_memory_size('Over 256GB')
        expect(inventories.count).to eq(2)
      end
      it 'by price range' do
        inventories = Inventory.by_price('Under 10 million VND')
        expect(inventories.count).to eq(2)
        inventories = Inventory.by_price('From 10 to 15 million VND')
        expect(inventories.count).to eq(2)
        inventories = Inventory.by_price('From 15 to 20 million VND')
        expect(inventories.count).to eq(2)
        inventories = Inventory.by_price('From 20 to 30 million VND')
        expect(inventories.count).to eq(2)
        inventories = Inventory.by_price('Over 30 million VND')
        expect(inventories.count).to eq(1)
      end
      it 'by status' do
        inventories = Inventory.by_status(:active)
        expect(inventories.count).to eq(2)
        inventories = Inventory.by_status(:inactive)
        expect(inventories.count).to eq(2)
        inventories = Inventory.by_status(:sold)
        expect(inventories.count).to eq(1)
      end
      it 'by os_version' do
        inventories = Inventory.by_os_version('iOS 14')
        expect(inventories.count).to eq(2)
        inventories = Inventory.by_os_version('Android 5')
        expect(inventories.count).to eq(2)
        inventories = Inventory.by_os_version('Android 11')
        expect(inventories.count).to eq(1)
      end
      it 'by color' do
        inventories = Inventory.by_color('black')
        expect(inventories.count).to eq(3)
        inventories = Inventory.by_color('green')
        expect(inventories.count).to eq(2)
      end
    end

    context 'records not found' do
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
