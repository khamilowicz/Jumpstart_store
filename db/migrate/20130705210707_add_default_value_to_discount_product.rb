class AddDefaultValueToDiscountProduct < ActiveRecord::Migration
  def up
    change_column :products, :discount, :integer, default: 100
  end

  def down
    change_column :products, :discount, :integer
  end
end
