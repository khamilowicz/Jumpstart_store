class AddStatusChangeDateToOrder < ActiveRecord::Migration
  def change
    add_column :orders, :status_change_date, :datetime
  end
end
