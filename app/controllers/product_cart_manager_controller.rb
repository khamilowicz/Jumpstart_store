class ProductCartManagerController < ApplicationController

  def join
    @product = Product.find(params[:id])
    user = specified_user
    user.add product: @product

    # @products = Product.find_on_sale.page params[:page]
    # @products_presenter = ProductPresenter.new_from_array @products

    @product_presenter = ProductPresenter.new @product

    respond_to do |format|
      format.html {redirect_to :back, notice: "#{product.title} added to cart"}
      format.js {render 'products/update_short'}
    end
  end

  def destroy
    product = Product.find(params[:id])
    user = specified_user
    user.remove product: product
    @product_presenter = ProductPresenter.new product

    respond_to do |format|
      format.html {redirect_to :back, notice: "#{product.title} removed from cart"}
      format.js {render 'products/update_short'}
    end
  end

  private

  def specified_user
    params[:user_id].empty? ? current_user : User.find(params[:user_id])
  end
end