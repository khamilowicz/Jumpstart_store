class CartsController < ApplicationController

	def show
		@products = current_user.cart.products 
	end

end