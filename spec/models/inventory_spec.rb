# frozen_string_literal: true

require 'rails_helper'

RSpec.describe Inventory, type: :model do
  describe '.new' do
    let(:brand) { Brand.create(name: 'Apple') }
    let(:model) { Model.create(name: 'iPhone X', brand: brand) }
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

  describe '.update' do
  end
end
