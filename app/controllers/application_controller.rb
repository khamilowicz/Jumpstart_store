class ApplicationController < ActionController::Base
	protect_from_forgery

	# rescue_from ActiveRecord::RecordNotFound do 
		# redirect_to root_url
	# end

	private

	def current_user
		return make_guest unless session[:current_user_id]
		User.where(id: session[:current_user_id]).first || make_guest
	end

	def make_guest
		user = User.create_guest
		session[:current_user_id] = user.id
		user
	end
	
	def ensure_not_guest
		redirect_to root_url, notice: "You can't see this content. Log in first" if current_user.guest?
	end

	def authorize_admin
		redirect_to root_url, notice: "You have to be an admin" unless current_user.admin?
	end


	helper_method :current_user
end
