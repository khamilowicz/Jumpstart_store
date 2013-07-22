class CreateTablesAddress < ActiveRecord::Migration
  def up
    create_table :address do |t|
      t.string :country
      t.string :city
      t.integer :zip_code
      t.string :street
      t.integer :house_nr
      t.integer :door_nr
    end
  end

  def down
    drop_table :address
  end
end
