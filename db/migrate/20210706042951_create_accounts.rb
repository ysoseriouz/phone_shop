class CreateAccounts < ActiveRecord::Migration[6.1]
  def change
    create_table :accounts do |t|
      t.string :username, null: false, unique: true
      t.string :password, null: false

      t.timestamps
    end
  end
end
