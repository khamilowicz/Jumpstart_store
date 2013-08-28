class AddDescriptionToAsset < ActiveRecord::Migration
  def change
    add_column :assets, :description, :text
  end
end
