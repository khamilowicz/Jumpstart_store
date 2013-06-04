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

	def update
		@product = Product.find(params[:id])

		if @product.update_attributes(params[:product])
		# binding.pry
			redirect_to products_path, notice: "Successfully updated product"
		else
			redirect_to edit_product_path(@product), notice: "Error"
		end
	end

	def create

		product = Product.new(params[:product])

		product.start_selling

		if product.save
			redirect_to products_path, notice: "Successfully created product"
		else
			redirect_to new_product_path, notice: "Error"
		end
	end

	def show
		@product = Product.find(params[:id])
	end

end