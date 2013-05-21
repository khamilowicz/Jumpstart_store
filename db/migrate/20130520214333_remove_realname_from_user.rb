class RemoveRealnameFromUser < ActiveRecord::Migration
  def up
  	remove_column :users, :realname
  end

  def down
  	add_column :users, :realname, :string
  end
end
