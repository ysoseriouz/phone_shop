# frozen_string_literal: true

# == Schema Information
#
# Table name: models
#
#  id            :integer          unsigned, not null, primary key
#  name          :string (256)     not null
#  brand_id      :integer          unsigned, not null, foreign key
#  created_at    :datetime
#  updated_at    :datetime
#

FactoryBot.define do
  factory :model do
    name { 'iPhone X' }
    brand { Brand.first || association(:brand) }
  end
end
