class Cart < ActiveRecord::Base
	belongs_to :user

	def products
    self.user.products.joins(:product_users).where('product_users.in_cart' => true)
	end

  def total_price
    self.products.total_price
  end
	
end
