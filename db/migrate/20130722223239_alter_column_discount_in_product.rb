class AlterColumnDiscountInProduct < ActiveRecord::Migration
  def up
  	change_column :products, :discount, :integer, default: 0
  end

  def down
  	change_column :products, :discount, :integer, default: 100
  end
end
