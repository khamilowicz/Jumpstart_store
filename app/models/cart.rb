class Cart < ActiveRecord::Base
	belongs_to :user

	def products
		ProductUser.joins(:product).where(user_id: self.user, in_cart: true).all.collect(&:product)
	end

  def total_price
    Product.total_price(self.products)
  end
	
end
