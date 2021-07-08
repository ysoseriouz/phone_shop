class AddThumbnailRefToInventory < ActiveRecord::Migration[6.1]
  def change
    add_reference :inventories, :thumbnail, null: true, foreign_key: {to_table: :photos}
  end
end
