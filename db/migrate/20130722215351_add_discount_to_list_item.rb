class AddDiscountToListItem < ActiveRecord::Migration
  def change
    add_column :list_items, :discount, :integer, default: 0
  end
end
