class SessionController < ApplicationController
	def new
		@session = Session.new
	end

	def delete
		session[:current_user_id] = nil
		redirect_to new_session_path, notice: "You are logged out"
	end

	def create
		user = User.authenticate params[:session]
		
		if user 
			User.transfer_products from: current_user, to: user
			session[:current_user_id] = user.id
			redirect_to new_session_path, notice: "Successfully logged in"
		else
			flash[:errors] =  "Wrong password or email pass"
			redirect_to new_session_path
		end
	end
end
