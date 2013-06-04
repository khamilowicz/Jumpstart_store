class ProductCartManagerController < ApplicationController

  def join
    product = Product.find(params[:id])
    user = specified_user
    user.add product: product


    respond_to do |format|
      format.html {redirect_to products_path, notice: "#{product.title} added to cart"}
      # format.html { render controller: 'products', action: 'index'}
    end
  end

  def destroy
    product = Product.find(params[:id])
    user = specified_user
    user.remove product: product

    respond_to do |format|
      format.html {redirect_to :back, notice: "#{product.title} removed from cart"}
    end
  end

  private

  def specified_user
    params[:user_id].empty? ? current_user : User.find(params[:user_id])
  end
end