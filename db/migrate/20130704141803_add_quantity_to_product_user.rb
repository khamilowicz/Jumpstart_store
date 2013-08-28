class AddQuantityToProductUser < ActiveRecord::Migration
  def change
    add_column :product_users, :quantity, :integer, default: 0
  end
end
