class AddRoleRefToAccounts < ActiveRecord::Migration[6.1]
  def change
    add_reference :accounts, :role, null: false, foreign_key: true
  end
end
