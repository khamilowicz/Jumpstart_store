class RemoveCartTable < ActiveRecord::Migration
  def up
    drop_table :carts
  end

  def down
    create_table :carts do |t|
      t.belongs_to :user

      t.timestamps
    end
    add_index :carts, :user_id
  end
end
