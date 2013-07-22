class AddDiscountToProduct < ActiveRecord::Migration
  def change
    add_column :products, :discount, :integer, default: 100
  end
end
