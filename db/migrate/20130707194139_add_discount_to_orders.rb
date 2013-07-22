class AddDiscountToOrders < ActiveRecord::Migration
  def change
    add_column :orders, :discount, :integer, default: 100
  end
end
