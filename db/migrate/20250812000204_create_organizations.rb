class CreateOrganizations < ActiveRecord::Migration[7.2]
  def change
    create_table :organizations do |t|
      t.string :name, null: false
      t.boolean :active, default: true, null: false

      t.timestamps
    end
    
    add_index :organizations, :name, unique: true
    add_index :organizations, :active
  end
end
