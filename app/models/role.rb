# frozen_string_literal: true

# Role model mapped to Roles table in database
class Role < ApplicationRecord
  has_many :accounts, dependent: :destroy

  validates :name, presence: true, uniqueness: { case_sensitive: false }
end
