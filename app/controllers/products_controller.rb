class ProductsController < ApplicationController

	def index
		@products = Product.find_on_sale.all
	end

	def show
		@product = Product.find(params[:id])
	end

	def add_to_cart
		product = Product.find(params[:id])
		current_user.add_product product

		redirect_to products_path, notice: "#{product.title} added to cart"
	end

	def remove_from_cart
		product = Product.find(params[:id])
		current_user.remove_product product
		
		redirect_to cart_path, notice: "#{product.title} removed from cart"
	end



end