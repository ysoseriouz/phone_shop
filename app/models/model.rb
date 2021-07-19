# frozen_string_literal: true

# Model model mapped to Models table in database
class Model < ApplicationRecord
  belongs_to :brand
  has_many :inventories, dependent: :destroy

  validates_associated :brand
  validates :name, presence: true, uniqueness: { case_sensitive: false }
end
