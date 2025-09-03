class ChangeTimeRemainingDefaultToTwelveMinutes < ActiveRecord::Migration[7.2]
  def change
    change_column_default :scoreboards, :time_remaining, from: "15:00", to: "12:00"
  end
end
