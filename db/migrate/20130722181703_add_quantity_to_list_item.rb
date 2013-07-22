class AddQuantityToListItem < ActiveRecord::Migration
  def change
    add_column :list_items, :quantity, :integer, default: 1
  end
end
