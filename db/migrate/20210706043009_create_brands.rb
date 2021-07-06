class CreateBrands < ActiveRecord::Migration[6.1]
  def change
    create_table :brands do |t|
      t.string :name, null: false, unique: true

      t.timestamps
    end
  end
end
