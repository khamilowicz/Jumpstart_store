class OrdersController < ApplicationController

	before_filter :ensure_not_guest
	before_filter :authorize_user, except: [:new, :create, :index, :filter]
	before_filter :authorize_admin, except: [:create, :new, :show, :index]

	def new
		# @products = current_user.cart.products
		@products = current_user.products
		@cart = current_user.cart
		@order = current_user.orders.new
	end

	def change_status
		@order = Order.find(params[:order_id])

		if Order::STATUSES.keys.include? params.fetch(:status).to_sym
			@order.set_status params[:status]
			@order.save
			@orders = Order.all
			redirect_to orders_path, notice: "Successfully updated order status to '#{@order.status}'"
		else
			flash[:error] = "Something went wrong"
			redirect_to order_path(@order)
		end
	end

	def filter
		@orders = Order.find_by_status(params[:status])
		respond_to do |format|
			format.html {render :index}
			format.js {render :index}
		end
	end

	def create
		user, paymillToken = current_user, params[:paymillToken]
		currency, address = current_user.cart.currency, params[:address]
		payManager = PaymillManager.new

		if ( payManager.transaction(user, paymillToken, currency) &&
			OrderConstructor.construct(user, address).save )
		render :show, notice: "Order is processed"
	else 
		flash[:errors] = payManager.error_message
	render :new	
	end
end

def index
	@orders = current_user.admin? ? Order.all : current_user.orders
end

def show
	@order = Order.find(params[:id])
	@user = UserPresenter.new @order.user
	@order_products = ProductPresenter.new_from_array @order.order_products, current_user
end

private

def authorize_user
	unless current_user.admin?
		user_id = Order.joins(:user).find(params[:order_id] || params[:id]).user.id
		redirect_to(new_session_path, :notice => "You are not allowed to see other user's order") unless current_user.id == user_id
	end
end
end
