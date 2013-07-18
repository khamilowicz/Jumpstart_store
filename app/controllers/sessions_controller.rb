class SessionsController < ApplicationController
	def new
		@session = Session.new
	end

	def destroy
		session[:current_user_id] = nil
		clean_current_user_cache
		redirect_to new_session_path, notice: "You are logged out"
	end

	def create
		user = Session.authenticate params[:session]
		
		if user 
			User.transfer_products from: current_user, to: user
			session[:current_user_id] = user.id
			redirect_to root_url, notice: "Successfully logged in"
		else
			flash[:errors] =  "Wrong password or email pass"
			redirect_to new_session_path
		end
	end
end
