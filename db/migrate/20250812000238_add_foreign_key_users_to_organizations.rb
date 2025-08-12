class AddForeignKeyUsersToOrganizations < ActiveRecord::Migration[7.2]
  def change
    add_foreign_key :users, :organizations
  end
end
