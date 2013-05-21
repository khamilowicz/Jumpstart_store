class AddRealnameNickEmailAdminGuestToUser < ActiveRecord::Migration
  def change
    add_column :users, :realname, :string
    add_column :users, :nick, :string
    add_column :users, :email, :string
    add_column :users, :admin, :boolean, default: false
    add_column :users, :guest, :boolean, default: true
  end
end
