class CreateSalesTables < ActiveRecord::Migration
  def up
    create_table :sales do |t|
      t.integer :discount
      t.string :name

      t.timestamps
    end
  end

  def down
    drop_table :sales
  end
end
