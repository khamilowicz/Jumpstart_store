class ProductUser < ActiveRecord::Base
  # attr_accessible :product_id, :user_id
  belongs_to :user
  belongs_to :product

  after_initialize :set_in_cart_status

  def set_in_cart_status
  	self.in_cart = true
  end
end
