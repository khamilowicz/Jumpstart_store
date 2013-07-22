class RenameColumnPriceToBasePriceInProducts < ActiveRecord::Migration
  def up
  	rename_column :products, :price, :base_price
  end

  def down
  	rename_column :products, :base_price, :price
  end
end
