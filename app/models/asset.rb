class Asset < ActiveRecord::Base
  # attr_accessible :title, :body
  attr_accessible :photo
  belongs_to :product
  has_attached_file :photo, :default_url => "/images/missing/missing.png"

  class << self
    def photos_for item
      item.assets.all.map(&:photo)
    end
  end
end
