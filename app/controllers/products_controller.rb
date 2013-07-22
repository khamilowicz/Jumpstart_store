class ProductsController < ApplicationController
	before_filter :authorize_admin, except: [:index, :show]

	def index
		@products = Product.find_on_sale.page params[:page]
	end


	def show
		@product = ProductPresenter.new Product.includes(:reviews, reviews: :user).find(params[:id]), current_user
	end

end