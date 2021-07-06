class AddBrandRefToModels < ActiveRecord::Migration[6.1]
  def change
    add_reference :models, :brand, null: false, foreign_key: true
  end
end
