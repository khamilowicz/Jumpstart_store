class SalesController < ApplicationController
  def new
  end

  def delete
    @product = Product.find(params[:product])
    @product.off_discount
    @products = ProductPresenter.new_from_array Sale.products

    respond_to do |format|
      format.html {redirect_to sales_url}
      format.js {render :index}
    end
  end

  def index
    @products = ProductPresenter.new_from_array Sale.products
  end

  def create
    @sale = Sale.new_from_params params
    @sale.discount_all
    
    redirect_to products_path
  end
end