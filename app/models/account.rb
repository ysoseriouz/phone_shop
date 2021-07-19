# frozen_string_literal: true

# Account model mapped to Accounts table in database
class Account < ApplicationRecord
  # Include default devise modules. Others available are:
  # :confirmable, :lockable, :timeoutable, :trackable and :omniauthable
  devise :database_authenticatable, :registerable,
         :recoverable, :rememberable, :validatable

  belongs_to :role

  validates_associated :role

  def manager?
    role.name == 'Manager'
  end
end
