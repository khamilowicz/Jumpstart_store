class AddPriceToOrders < ActiveRecord::Migration
  def change
    add_money :orders, :price
  end
end
