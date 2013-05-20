class Product < ActiveRecord::Base
  # attr_accessible :title, :body
  validates :title, presence: true, uniqueness: true
  validates_presence_of :description
validates :price, :format => { :with => /^\d+??(?:\.\d{0,2})?$/ }, :numericality => {:greater_than => 0}
validates :photo, format: {with: %r{https?://(www\.)?\w+(\.\w+)+} }, allow_nil: true

end
