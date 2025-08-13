class CreateScoreboards < ActiveRecord::Migration[7.2]
  def change
    create_table :scoreboards do |t|
      t.references :game, null: false, foreign_key: true
      t.string :type, null: false
      
      # Football-specific fields
      t.integer :home_score, default: 0
      t.integer :visitor_score, default: 0
      t.integer :quarter, default: 1
      t.string :time_remaining, default: "15:00"
      
      # Future sport-specific fields can be added here
      # Basketball: period, shot_clock, etc.
      # Soccer: half, stoppage_time, etc.

      t.timestamps
    end
    
    add_index :scoreboards, :type
  end
end
