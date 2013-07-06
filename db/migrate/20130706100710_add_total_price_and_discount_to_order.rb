class AddTotalPriceAndDiscountToOrder < ActiveRecord::Migration
  def change
    add_column :orders, :discount, :integer
    add_money :orders, :total_price
  end
end
