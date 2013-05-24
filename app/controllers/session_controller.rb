class SessionController < ApplicationController
	def new
		@session = Session.new
	end

	def delete
		session[:user_id] = nil
		redirect_to session_new_path, notice: "You are logged out"
	end

	def create
		session_args = params[:session]
		user = User.where(email: session_args[:email]).first
		if user && user.password == session_args[:password]
			current_user.products.each do |product|
				current_user.remove_product product
				user.add_product product
			end
			session[:user_id] = user.id
			redirect_to session_new_path, notice: "Successfully logged in"
		else
			redirect_to session_new_path, notice: "Wrong password or email pass #{session_args[:password]} email #{session_args[:email]}     params #{params}"
		end
	end
end
