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
		@product = Product.find(params[:id])
		@categories = Category.all
	end

	def add_to_category
		@product = Product.find(params[:id])
		@product.add_to_category params[:new_category] unless params[:new_category].empty?
		@product.add_to_category params[:categories].values if  params[:categories]
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
		current_user.add_product product

		redirect_to products_path, notice: "#{product.title} added to cart"
	end

	def remove_from_cart
		product = Product.find(params[:id])
		current_user.remove_product product

		redirect_to cart_path, notice: "#{product.title} removed from cart"
	end



end