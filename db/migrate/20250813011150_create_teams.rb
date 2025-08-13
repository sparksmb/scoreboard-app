class CreateTeams < ActiveRecord::Migration[7.2]
  def change
    create_table :teams do |t|
      t.string :name, null: false
      t.string :primary_color
      t.string :secondary_color
      t.references :organization, null: false, foreign_key: true

      t.timestamps
    end
    
    add_index :teams, [:organization_id, :name], unique: true
  end
end
