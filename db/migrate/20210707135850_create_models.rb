# frozen_string_literal: true

# Create Models table in connected database
class CreateModels < ActiveRecord::Migration[6.1]
  def change
    create_table :models do |t|
      t.string :name, null: false
      t.references :brand, null: false, foreign_key: true

      t.timestamps
    end
  end
end
