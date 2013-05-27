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
    categories = params[:categories]
    products = params[:products]
    discount = params[:discount].to_i
      # binding.pry
    if categories
      categories.each do |key, value|
        Category.find(key).discount discount
      end
    end
    if products
      products.each do |key, value|
        Product.find(key).on_discount discount
      end
    end
    redirect_to products_path
  end
end