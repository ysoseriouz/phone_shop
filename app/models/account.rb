class Account < ApplicationRecord
  belongs_to :role

  validates_associated :role
  validates :username, :encrypted_password, :email, presence: true
end
