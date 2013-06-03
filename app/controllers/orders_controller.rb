class OrdersController < ApplicationController
	before_filter :ensure_not_guest
	before_filter :authorize_user, except: [:new, :create, :index]
	before_filter :authorize_admin, except: [:filter, :create, :new, :show, :index]

	def new
		@products = current_user.cart.products
	end

	def change_status
		order = Order.find(params[:order_id])
		order.set_status params[:status]

		@orders = Order.all
		redirect_to orders_path, notice: "Successfully updated order status to '#{order.status}'"
	end

	def filter
		@orders = Order.find_by_status(params[:status])
		render 'index'
	end

	def create
par = {
	amount: current_user.cart.total.to_i.to_s,
	currency: 'EUR',
	token: params[:paymillToken],
	description: 'Can it be?'
}
		trans = Paymill::Transaction.create(par)
		binding.pry
		
		@order = Order.new
		@order.user = current_user
		@order.transfer_products
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
		@order = Order.find(params[:id])
	end

	private

	def authorize_user
		unless current_user.admin?
			@order = Order.find(params[:order_id] || params[:id])
			redirect_to(root_url, :notice => "You can't see other user's order") unless current_user.id == @order.user.id
		end
	end
end
