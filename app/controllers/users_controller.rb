class UsersController < ApplicationController
  before_filter :authorize_user

  def show
    @user = User.find(params[:id])
  end

  private

  def authorize_user
    unless current_user.admin?
      if current_user.id.to_s != params[:id]
        redirect_to root_url, notice: "You can't see other user's profile"
      end
    end
  end
end