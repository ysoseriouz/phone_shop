class Inventory < ApplicationRecord
  belongs_to :model, -> { includes :brand }
  has_many_attached :images, dependent: :destroy
  enum status: {
    active: 0,
    sold: 1,
    inactive: 2
  }, _prefix: true

  validates_associated :model
  validates :memory_size, :manufactoring_year, :os_version, :color, :price, presence: true

  validates :memory_size, numericality: { only_integer: true, greater_than: 0 }
  validates :manufactoring_year, numericality: { only_integer: true, greater_than: 0,
                                                 less_than_or_equal_to: Time.zone.now.year }
  validates :price, numericality: { greater_than_or_equal_to: 0 }
end
