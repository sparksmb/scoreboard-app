class CreateGames < ActiveRecord::Migration[7.2]
  def change
    create_table :games do |t|
      t.references :organization, null: false, foreign_key: true
      t.references :home_team, null: false, foreign_key: { to_table: :teams }
      t.references :visitor_team, null: false, foreign_key: { to_table: :teams }
      t.datetime :game_date, null: false
      t.string :location
      t.text :description

      t.timestamps
    end
    
    add_index :games, :game_date
    add_index :games, [:organization_id, :game_date]
  end
end
