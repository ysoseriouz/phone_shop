# frozen_string_literal: true

# == Schema Information
#
# Table name: accounts
#
#  id                     :integer          unsigned, not null, primary key
#  email                  :string (256)     default (''), not null, unique index
#  encrypted_password     :string (256)     default (''), not null
#  name                   :string (256)     default (''), not null
#  role_id                :integer          unsigned, not null, foreign key
#  reset_password_token   :string (256)
#  reset_password_sent_at :datetime
#  remember_created_at    :datetime
#  created_at             :datetime
#  updated_at             :datetime
#

FactoryBot.define do
  factory :account do
    email { 'user@example.com' }
    password { 'password' }
    password_confirmation { 'password' }
    name { 'Test User' }
    role { Role.first || association(:role) }
  end
end
