class AddFieldsToUsers < ActiveRecord::Migration[7.2]
  def change
    add_column :users, :first_name, :string, null: false
    add_column :users, :last_name, :string, null: false
    add_column :users, :organization_id, :bigint
    add_column :users, :admin, :boolean, default: false, null: false
    
    add_index :users, :organization_id
  end
end
