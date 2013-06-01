class AddDiscountToProduct < ActiveRecord::Migration
  def change
    add_column :products, :discount, :integer, defalut: 100
  end
end
