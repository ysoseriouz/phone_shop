class CreateInventories < ActiveRecord::Migration[6.1]
  def change
    create_table :inventories do |t|
      t.integer :memory_size, null: false
      t.integer :manufactoring_year, null: false
      t.string :os_version, null: false
      t.string :color, null: false
      t.decimal :price, null: false
      t.decimal :original_price
      t.string :source
      t.text :description

      t.timestamps
    end
  end
end
