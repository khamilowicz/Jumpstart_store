class SalesController < ApplicationController
  def new
  end

  def delete
    @product = Product.find(params[:product])
    @product.off_discount
    @products = Product.where('discount !=?', 100).all

    respond_to do |format|
      format.html {redirect_to sales_url}
      format.js {render :index}
    end
  end

  def index
    @products = ProductPresenter.new_from_array Product.where('discount !=?', 100).all
  end

  def create
    Sale.build params
    Sale.discount_all
    
    redirect_to products_path
  end
end