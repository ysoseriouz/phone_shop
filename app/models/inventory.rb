class Inventory < ApplicationRecord
  belongs_to :model, -> { includes :brand }
  has_many_attached :images, dependent: :destroy
  enum status: {
    active: 0,
    sold: 1,
    inactive: 2
  }, _prefix: true

  # Validations
  validates_associated :model
  validates :memory_size, :manufactoring_year, :os_version, :color, :price, presence: true

  validates :memory_size, numericality: { only_integer: true, greater_than: 0 }
  validates :manufactoring_year, numericality: { only_integer: true, greater_than: 0,
                                                 less_than_or_equal_to: Time.zone.now.year }
  validates :price, numericality: { greater_than_or_equal_to: 0 }

  class_attribute :memory_size_options, :price_options

  enum memory_size_range: {
    "< 16 GB" => 0,
    "16 -> 64 GB" => 1,
    "64 -> 256 GB" => 2,
    "> 256 GB" => 3
  }
  enum price_range: {
    "< 10 tr" => 0,
    "10 -> 15 tr" => 1,
    "15 -> 20 tr" => 2,
    "20 -> 30 tr" => 3,
    "> 30 tr" => 4
  }
end
