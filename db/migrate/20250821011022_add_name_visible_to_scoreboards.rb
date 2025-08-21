class AddNameVisibleToScoreboards < ActiveRecord::Migration[7.2]
  def change
    add_column :scoreboards, :name_visible, :boolean, default: false
  end
end
