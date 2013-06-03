class CartsController < ApplicationController

  # before_filter :authorize_user

	def show
		@products = current_user.products 
    respond_to do |format|
      format.html
      format.js {render :show}
    end
	end

  private

  def authorize_user
    redirect_to root_url, notice: "You can't see other user's cart" if current_user.guest?
  end

end