class ProductCartManagerController < ApplicationController
  def join
    product = Product.find(params[:id])
    user = specified_user
    user.add_product product

    redirect_to products_path, notice: "#{product.title} added to cart"
  end

  def destroy
    product = Product.find(params[:id])
    user = specified_user
    user.remove_product product

    redirect_to cart_path, notice: "#{product.title} removed from cart"
  end

  private

  def specified_user
    params[:user_id].empty? ? current_user : User.find(params[:user_id])
  end
end