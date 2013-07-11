class CreateProductsSalesTable < ActiveRecord::Migration
  def up
    create_table :products_sales do |t|
      t.integer :product_id
      t.integer :sale_id
    end
  end

  def down
    drop_table :products_sales
  end
end
