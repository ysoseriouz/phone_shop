class Model < ApplicationRecord
  belongs_to :brand
  has_many :inventories, dependent: :destroy

  validates_associated :brand
  validates :name, presence: true, uniqueness: { case_sensitive: false }
end
