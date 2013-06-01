class ProductCategoryManagerController < ApplicationController

  def new
      @product = Product.find(params[:product_id])
    @categories = Category.all 
    render 'products/new_add_to_category'
  end
  
  def join
   @product = Product.find(params[:product_id])
    @product.add category: params
    redirect_to product_path(@product) 
  end


end