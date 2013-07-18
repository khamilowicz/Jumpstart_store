class AddDiscountToOrderProduct < ActiveRecord::Migration
  def change
    add_column :order_products, :discount, :integer, default: 100
  end
end
