class AddPriceToOrderProduct < ActiveRecord::Migration
  def change
    add_money :order_products, :base_price
  end
end
