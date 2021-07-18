class Role < ApplicationRecord
  has_many :accounts, dependent: :destroy

  validates :name, presence: true, uniqueness: { case_sensitive: false }
end
