# frozen_string_literal: true

require 'rails_helper'

RSpec.describe Brand, type: :model do
  describe '.new' do
    let(:brand) { build(:brand) }

    it 'belongs to Brand class' do
      expect(brand).to be_a Brand
    end

    context 'with valid attributes' do
      it 'is valid' do
        expect(brand).to be_valid
      end
    end

    context 'without a name' do
      it 'is invalid' do
        brand.name = nil
        expect(brand).to_not be_valid
      end
    end
  end

  describe '.create' do
    let!(:brand) { create(:brand) }

    context 'with an existed brand name' do
      it 'is invalid' do
        new_brand = build(:brand)
        expect(new_brand).to_not be_valid
      end
    end
  end

  describe '.destroy' do
    before(:all) do
      @brand = create(:brand)
      create(:model, brand: @brand)
    end

    context 'when referenced by a model' do
      it 'destroy referencing model' do
        expect(Brand.count).to eq(1)
        expect(Model.count).to eq(1)
        @brand.destroy
        expect(Brand.count).to eq(0)
        expect(Model.count).to eq(0)
      end
    end
  end
end
