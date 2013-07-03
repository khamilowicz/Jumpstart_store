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

  def new_join_many
    @product_category = ProductCategoryManager.new
  end

  def join_many

    @product_category_manager = ProductCategoryManager.new params[:product_category_manager]
    @product_category_manager.join

    redirect_to controller: :categories, action: :index , notice: 'Successfully categorized products'
  end


end