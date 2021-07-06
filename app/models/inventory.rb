class Inventory < ApplicationRecord
  belongs_to :model, -> { includes :brand }
  belongs_to :album
  enum status: {
    active: 0,
    sold: 1,
    inactive: 2
  }
end
