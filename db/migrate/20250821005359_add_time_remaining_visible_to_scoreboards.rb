class AddTimeRemainingVisibleToScoreboards < ActiveRecord::Migration[7.2]
  def change
    add_column :scoreboards, :time_remaining_visible, :boolean, default: false
  end
end
