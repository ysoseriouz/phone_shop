# frozen_string_literal: true

# Create Brands table in connected database
class CreateBrands < ActiveRecord::Migration[6.1]
  def change
    create_table :brands do |t|
      t.string :name, null: false

      t.timestamps
    end

    add_index :brands, :name, unique: true
  end
end
