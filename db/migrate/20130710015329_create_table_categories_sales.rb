class CreateTableCategoriesSales < ActiveRecord::Migration
  def up
    create_table :categories_sales do |t|
      t.integer :category_id
      t.integer :sale_id
    end
  end

  def down
    drop_table :categories_sales
  end
end
