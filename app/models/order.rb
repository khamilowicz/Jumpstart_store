class Order < ActiveRecord::Base
  belongs_to :user
  has_many :products 
  # attr_accessible :title, :body
end
