class SessionController < ApplicationController
	def new
		@session = Session.new
	end

	def delete
		session[:current_user_id] = nil
		redirect_to new_session_path, notice: "You are logged out"
	end

	def create
		session_args = params[:session]
		user = User.where(email: session_args[:email]).first
		if user && user.password == session_args[:password]
			current_user.products.each do |product|
				current_user.remove_product product
				user.add_product product
			end
			session[:current_user_id] = user.id
			redirect_to new_session_path, notice: "Successfully logged in"
		else
			flash[:errors] =  "Wrong password or email pass"
			redirect_to new_session_path
		end
	end
end
