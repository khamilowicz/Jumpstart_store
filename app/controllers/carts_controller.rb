class CartsController < ApplicationController

  def show
    @products = ProductPresenter.new_from_array current_user.products 
    respond_to do |format|
      format.html
      format.js {render :show}
    end
  end
end