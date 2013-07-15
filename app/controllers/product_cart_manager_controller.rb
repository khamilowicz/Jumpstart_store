class ProductCartManagerController < ApplicationController
  
  skip_before_filter :ensure_not_guest

  def join
    @product = Product.find(params[:id])
    user = specified_user
    user.add product: @product

    @product_presenter = ProductPresenter.new @product

    respond_to do |format|
        format.html {redirect_to :back, notice: "#{@product.title} added to cart"}
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