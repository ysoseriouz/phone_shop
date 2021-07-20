require 'rails_helper'

RSpec.describe Inventory, type: :model do
  context 'New Inventory' do
    it 'is valid with valid attributes'
    it 'is not valid without belonging to a Model'
    it 'is not valid without memory_size'
    it 'is not valid without manufactoring_year'
    it 'is not valid without os_version'
    it 'is not valid without color'
    it 'is not valid without price'
    it 'is not valid if model is not existed'
    it 'is not valid if memory_size is not a positive integer number'
    it 'is not valid if manufactoring_year is not a reasonable year (positive integer and <= current year)'
    it 'is not valid if price is negative price'
  end
end
