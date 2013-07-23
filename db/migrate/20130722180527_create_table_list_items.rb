class CreateTableListItems < ActiveRecord::Migration
  def up
  	create_table :list_items do |t|
  		t.references :holder, polymorphic: true
  	end
  end

  def down
  	drop_table :list_items
  end
end
