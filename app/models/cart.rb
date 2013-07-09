class Cart 

  def initialize user
    @user = user
  end

	def products
    @user.products.joins(:product_users).where(product_users: {in_cart: true})
	end

  def total_price
    self.products.total_price
  end
end
