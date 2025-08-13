class AddMascotToTeams < ActiveRecord::Migration[7.2]
  def change
    add_column :teams, :mascot, :string
  end
end
