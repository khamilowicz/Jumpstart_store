class UsersController < ApplicationController
  before_filter :authorize_user

  def show
    @user = User.find(params[:id])
  end

  private

  def authorize_user
   if current_user.id != params[:id].to_s
    redirect_to root_url, notice: "You can't see other user's profile"
  end
end
end