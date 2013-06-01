class SalesController < ApplicationController
  def new
  end

  def delete
    @product = Product.find(params[:product])
    @product.off_discount

    redirect_to sales_url
  end

  def index
    @products = Product.where('discount !=?', 100).all
  end

  def create
    Sale.build params
    Sale.discount_all
    
    redirect_to products_path
  end
end