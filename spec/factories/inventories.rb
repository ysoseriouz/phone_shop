# frozen_string_literal: true

# == Schema Information
#
# Table name: inventories
#
#  id                 :integer          unsigned, not null, primary key
#  model_id           :integer          unsigned, not null, foreign key
#  memory_size        :integer          unsigned, not null
#  manufactoring_year :integer          unsigned, not null
#  os_version         :string (256)     not null
#  color              :string (256)     not null
#  price              :decimal (10, 2)  unsigned, not null
#  original_price     :decimal (10, 2)  unsigned
#  status             :integer          default (0), not null
#  source             :string (256)
#  description        :text
#  created_at         :datetime
#  updated_at         :datetime
#

FactoryBot.define do
  factory :inventory do
    memory_size { 18 }
    manufactoring_year { 2021 }
    os_version { 'iOS 14' }
    color { 'black' }
    price { 10_000_000 }
    status { :active }
    model { Model.first || association(:model) }
  end
end
