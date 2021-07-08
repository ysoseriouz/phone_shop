class Inventory < ApplicationRecord
  belongs_to :model, -> { includes :brand }
  enum status: {
    active: 0,
    sold: 1,
    inactive: 2
  }
end
