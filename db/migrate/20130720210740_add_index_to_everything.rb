class AddIndexToEverything < ActiveRecord::Migration
  def change
    add_index :addresses, :user_id, name: 'addresses_user_id_ix'
    add_index :addresses, :order_id, name: 'addresses_order_id_ix'
    add_index :assets, :product_id, name: 'assets_product_id_ix'
    add_index :categories_sales, :category_id, name: 'cat_sal_category_id_ix'
    add_index :categories_sales, :sale_id, name: 'cat_sal_product_id_ix'
    add_index :order_products, :order_id, name: 'ord_pro_order_id_ix'
    add_index :product_users, :product_id, name: 'pro_use_product_id_ix'
    add_index :product_users, :user_id, name: 'pro_use_user_id_ix'
    add_index :products, :order_id, name: 'products_order_id_ix'
    add_index :products_sales, :product_id, name: 'pro_sal_product_id_ix'
    add_index :products_sales, :sale_id, name: 'pro_sal_sale_id_ix'
    add_index :reviews, :user_id, name: 'reviews_user_id_ix'
    add_index :reviews, :product_id, name: 'reviews_product_id_ix'
  end
end
