class AddProductIdToListItem < ActiveRecord::Migration
  def change
    add_column :list_items, :product_id, :integer
    add_index :list_items, :product_id, name: 'list_item_product_idx'
    add_index :list_items, :holder_id, name: 'list_item_holder_idx'
  end
end
