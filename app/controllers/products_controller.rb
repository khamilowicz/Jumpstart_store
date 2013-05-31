class ProductsController < ApplicationController

	def index
		@products = Product.find_on_sale.all
	end

	def new
		@product = Product.new
	end

	def edit
		@product = Product.find(params[:id])
	end

	def new_add_to_category
		@product = Product.find(params[:product_id])
		@categories = Category.all
	end

	def add_to_category
		@product = Product.find(params[:product_id])
		@product.add_to_category params
		redirect_to product_path(@product)
	end

	def update
		@product = Product.find(params[:id])

		if @product.update_attributes(params[:product])
			redirect_to products_path, notice: "Successfully updated product"
		else
			redirect_to edit_product_path(@product), notice: "Error"
		end
	end

	def create

		@product = Product.new(params[:product])
		@product.start_selling

		if @product.save
			redirect_to products_path, notice: "Successfully created product"
		else
			redirect_to new_product_path, notice: "Error"
		end
	end

	def show
		@product = Product.find(params[:id])
	end

	def add_to_cart
		product = Product.find(params[:id])
		user = (params[:user_id].empty? ? current_user : User.find(params[:user_id]))
		user.add_product product

		redirect_to products_path, notice: "#{product.title} added to cart"
	end

	def remove_from_cart
		product = Product.find(params[:id])
		user = (params[:user_id].empty? ? current_user : User.find(params[:user_id]))
		user.remove_product product

		redirect_to cart_path, notice: "#{product.title} removed from cart"
	end
end