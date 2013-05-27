class OrdersController < ApplicationController
	before_filter :authorize_user

	def new
	end

	def change_status
		new_status = params[:status]
		order = Order.find(params[:id])
		case new_status
		when 'ship' then order.is_sent
		when 'cancel' then order.cancel
		when 'return' then order.is_returned
		end

		@orders = Order.all

		redirect_to orders_path, notice: "Successfully updated order status to '#{order.status}'"
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

	private

	def authorize_user
		if current_user.guest?
			redirect_to root_url, notice: "You can't see other user's orders"
		end
	end
end
