class CreateInventories < ActiveRecord::Migration[6.1]
  def change
    create_table :inventories do |t|
      t.integer :memory_size, null: false, unsigned: true
      t.integer :manufactoring_year, null: false, unsigned: true
      t.string :os_version, null: false
      t.string :color, null: false
      t.decimal :price, null: false, unsigned: true
      t.decimal :original_price, unsigned: true
      t.integer :status, null: false, default: 0   # Active
      t.string :source
      t.text :description
      t.references :model, null: false, foreign_key: true
      t.references :album, null:false, foreign_key: true

      t.timestamps
    end
  end
end
