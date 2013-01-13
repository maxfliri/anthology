class RenameUserIdentityProperties < ActiveRecord::Migration
  def change
    rename_column :users, :github_id, :uid
    rename_column :users, :github_login, :nickname
  end
end
