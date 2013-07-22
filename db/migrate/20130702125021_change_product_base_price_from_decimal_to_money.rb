class ChangeProductBasePriceFromDecimalToMoney < ActiveRecord::Migration
  def up
    remove_column :products, :base_price
    add_money :products, :base_price
  end

  def down
    remove_money :products, :base_price
    add_column :products, :base_price, :decimal, precision: 8, scale: 2
  end
end
