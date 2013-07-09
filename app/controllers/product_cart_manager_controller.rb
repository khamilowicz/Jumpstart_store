class ProductCartManagerController < ApplicationController

  def join
    product = Product.find(params[:id])
    user = specified_user
    user.add product: product

    respond_to do |format|
      format.html {redirect_to :back, notice: "#{product.title} added to cart"}
      format.js {render :back}
    end
  end

  def destroy
    product = Product.find(params[:id])
    user = specified_user
    user.remove product: product

    respond_to do |format|
      format.html {redirect_to :back, notice: "#{product.title} removed from cart"}
      format.js {render :back}
    end
  end

  private

  def specified_user
    params[:user_id].empty? ? current_user : User.find(params[:user_id])
  end
end