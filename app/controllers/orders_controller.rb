class OrdersController < ApplicationController
	before_filter :ensure_not_guest
	before_filter :authorize_user, except: [:new, :create, :index]
	before_filter :authorize_admin, except: [:filter, :create, :new, :show, :index]

	def new
	end

	def change_status
		new_status = params[:status]
		order = Order.find(params[:order_id])
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
		if current_user.admin?
			@orders = Order.all
		else
			@orders = current_user.orders.all
		end
	end

	def show
		@order = Order.find(params[:id])
	end

	private

	def authorize_user
		unless current_user.admin?
			@order = Order.find(params[:order_id] || params[:id])
			# binding.pry unless current_user.id == @order.user.id
			redirect_to(root_url, :notice => "You can't see other user's order") unless current_user.id == @order.user.id
		end
	end
end
