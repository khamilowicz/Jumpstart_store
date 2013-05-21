class Cart < ActiveRecord::Base
	belongs_to :user

	def products
		ProductUser.joins(:product).where(user_id: self.user, in_cart: true).all.collect(&:product)
	end
  # attr_accessible :title, :body
end
