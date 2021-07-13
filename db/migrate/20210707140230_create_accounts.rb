class CreateAccounts < ActiveRecord::Migration[6.1]
  def change
    create_table :accounts do |t|
      t.string :username, null: false
      t.string :encrypted_password, null: false
      t.string :email, null: false
      t.references :role, null: false, foreign_key: true

      t.timestamps
    end
    add_index :accounts, :username, unique: true
  end
end
