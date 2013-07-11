class ApplicationController < ActionController::Base
	protect_from_forgery

	private

	def current_user
		return make_guest unless session[:current_user_id]
		User.where(id: session[:current_user_id]).first || make_guest
	end

	def current_user_presenter
		UserPresenter.new current_user
	end

	def make_guest
		user = User.create_guest
		session[:current_user_id] = user.id
		user
	end
	
	def ensure_not_guest
		if current_user.guest?
			flash[:errors] =  "You are not allowed see this content. Log in first"
			redirect_to root_url
		end
	end
	
  def authorize_admin
    unless current_user.admin?
     flash[:notice] = "You are not allowed to see this content"
     redirect_to root_url
   end 
 end

   def authorize_user
    unless current_user.id.to_s == params[:id] 
      flash[:notice] = "You are not allowed to see this content"
      redirect_to root_url
    end
  end


 def authorize_user_or_admin
  unless current_user.id.to_s == params[:id] or current_user.admin?
    flash[:notice] = "You are not allowed to see this content"
    redirect_to root_url
  end
end


	helper_method :current_user, :current_user_presenter
end
