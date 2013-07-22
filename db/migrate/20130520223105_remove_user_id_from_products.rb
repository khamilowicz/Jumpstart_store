class RemoveUserIdFromProducts < ActiveRecord::Migration
  def up
  	remove_column :products, :user_id
  end

  def down
  	add_column :products, :user_id, :integer	
  end
end
