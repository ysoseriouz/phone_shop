class Album < ApplicationRecord
  has_many :photos
  belongs_to :photo   # thumbnail_id
end
