class ProductsController < ApplicationController

	def index
		@products = Product.find_on_sale.all
	end

	def show
		@product = Product.find(params[:id])
	end

	def add_to_cart
		@product = Product.find(params[:id])
		current_user.add_product @product

		redirect_to products_path
	end

	private

 def current_user
 	if session[:user_id]
 		return User.find(session[:user_id])
 	else
 		user = User.create_guest
 		session[:user_id] = user.id
 		return user
 	end
 end

end