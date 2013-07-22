class AddAttachmentToAsset < ActiveRecord::Migration
   def self.up
    add_attachment :assets, :photo
  end

  def self.down
    remove_attachment :assets, :photo
  end

end
