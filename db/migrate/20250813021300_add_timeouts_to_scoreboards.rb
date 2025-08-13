class AddTimeoutsToScoreboards < ActiveRecord::Migration[7.2]
  def change
    add_column :scoreboards, :home_timeouts_remaining, :integer, default: 3
    add_column :scoreboards, :visitor_timeouts_remaining, :integer, default: 3
  end
end
