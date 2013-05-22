class ApplicationController < ActionController::Base
	protect_from_forgery

	rescue_from ActiveRecord::RecordNotFound do 
		redirect_to root_url
	end

	private

	def current_user
		if session[:user_id]
			return User.find(session[:user_id])
		else
			user = User.create_guest
			session[:user_id] = user.id
			return user
		end
	end

	helper_method :current_user
end
