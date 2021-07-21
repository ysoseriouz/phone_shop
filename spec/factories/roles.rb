# frozen_string_literal: true

# == Schema Information
#
# Table name: roles
#
#  id            :integer          unsigned, not null, primary key
#  name          :string (256)     not null, unique index
#  created_at    :datetime
#  updated_at    :datetime
#

FactoryBot.define do
  factory :role do
    name { 'Manager' }
  end
end
