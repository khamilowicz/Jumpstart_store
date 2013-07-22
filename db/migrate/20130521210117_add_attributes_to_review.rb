	class AddAttributesToReview < ActiveRecord::Migration
  def change
    add_column :reviews, :title, :string
    add_column :reviews, :body, :text
    add_column :reviews, :note, :integer
    add_column :reviews, :user_id, :integer
  end
end
