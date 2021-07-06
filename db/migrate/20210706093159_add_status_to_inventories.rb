class AddStatusToInventories < ActiveRecord::Migration[6.1]
  def change
    add_column :inventories, :status, :integer
  end
end
