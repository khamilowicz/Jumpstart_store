class Asset < ActiveRecord::Base
  # attr_accessible :title, :body
  attr_accessible :photo
  belongs_to :product
  has_attached_file :photo
end
