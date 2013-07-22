class AddInCartToProductUser < ActiveRecord::Migration
  def change
    add_column :product_users, :in_cart, :boolean, default: false
  end
end
