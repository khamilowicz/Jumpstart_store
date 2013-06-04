class RemovePhotosFromProduct < ActiveRecord::Migration
 def self.up
    remove_attachment :products, :photo
  end

  def self.down
    add_attachment :products, :photo
  end
end
