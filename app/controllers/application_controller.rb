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
	
	def ensure_not_guest
		redirect_to root_url, notice: "You can't see this content. Log in first" if current_user.guest?
	end

	def authorize_admin
		redirect_to root_url, notice: "You have to be an admin" unless current_user.admin?
	end


	helper_method :current_user
end
