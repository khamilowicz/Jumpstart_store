class OrdersController < ApplicationController
	def new
	end

	def filter
		status = params[:status]
		@orders = Order.find_by_status(status)
		render 'index'
	end

	def create
		@order = current_user.orders.new
		@order.transfer_products
		## TODO: address
		@order.address = 'current_user.address'
		if @order.save
			redirect_to '/cart', notice: "Order is processed"
		else
			redirect_to '/cart', notice: "Something went wrong"
		end
	end

	def index
		@orders = current_user.orders.all
	end

	def show
		@order = current_user.orders.find(params[:id])
	end
end
