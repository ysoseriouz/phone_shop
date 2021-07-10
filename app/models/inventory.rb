class Inventory < ApplicationRecord
  belongs_to :model, -> { includes :brand }
  has_many_attached :images
  enum status: {
    active: 0,
    sold: 1,
    inactive: 2
  }, _prefix: true
end
