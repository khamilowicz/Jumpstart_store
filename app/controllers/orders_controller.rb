class OrdersController < ApplicationController
	before_filter :ensure_not_guest
	before_filter :authorize_user, except: [:new, :create, :index]
	before_filter :authorize_admin, except: [:filter, :create, :new, :show, :index]

	def new
		@products = ProductPresenter.new_from_array current_user.cart.products
		@cart = current_user.cart
		@order = current_user.orders.new
	end

	def change_status
		order = Order.find(params[:order_id])
		order.set_status params[:status]

		@orders = Order.all
		redirect_to orders_path, notice: "Successfully updated order status to '#{order.status}'"
	end

	def filter
		@orders = Order.find_by_status(params[:status])
		respond_to do |format|
			format.html {render 'index'}
			format.js {render :index}
		end
	end

	def create
		if PaymillManager.transaction(current_user, params[:paymillToken], current_user.cart.currency)
			@order = Order.init current_user, params[:address]
			@order.transfer_products
			@order.pay
		end

		if @order.save
			render :show, notice: "Order is processed"
		else
			flash[:errors] = "Something went wrong"
			redirect_to '/cart'
		end
	end

	def index
		@orders = current_user.admin? ? Order.all : current_user.orders
	end

	def show
		@order = Order.find(params[:id])
		@user = UserPresenter.new @order.user
		@products = ProductPresenter.new_from_array @order.products
	end

	private

	def authorize_user
		unless current_user.admin?
			user_id = Order.joins(:user).find(params[:order_id] || params[:id]).user.id
			redirect_to(root_url, :notice => "You are not allowed to see other user's order") unless current_user.id == user_id
		end
	end
end
