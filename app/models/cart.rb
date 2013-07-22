class Cart

  def initialize user
    @user = user
  end

  def currency
    self.total_price.currency
  end

  def empty?
    not products.any?
  end

	def products
    @user.products.joins(:product_users).where(product_users: {in_cart: true}).uniq
	end

  def total_price
    @user.product_users.total_price
  end
end
