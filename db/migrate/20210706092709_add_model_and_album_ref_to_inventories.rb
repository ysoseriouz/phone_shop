class AddModelAndAlbumRefToInventories < ActiveRecord::Migration[6.1]
  def change
    add_reference :inventories, :model, null: false, foreign_key: true
    add_reference :inventories, :album, null: false, foreign_key: true
  end
end
