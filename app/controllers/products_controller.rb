class ProductsController < ApplicationController

	def index
		@products = Product.find_on_sale.all
	end

	def show
		@product = Product.find(params[:id])
	end

end