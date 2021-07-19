# frozen_string_literal: true

# Brand model mapped to Brands table in database
class Brand < ApplicationRecord
  has_many :models, dependent: :destroy

  validates :name, presence: true, uniqueness: { case_sensitive: false }
end
