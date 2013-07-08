class ProductCategoryManagerController < ApplicationController

  def new
    @product = Product.find(params[:product_id])
    @categories = Category.all 
    render 'products/new_add_to_category'
  end
  
  def join
    @product = Product.find(params[:product_id])
    get_categories_names(params).each { |c| @product.add category: c }

    redirect_to product_path(@product) 
  end

  def new_join_many
    @product_category_manager = ProductCategoryManager.new
  end

  def join_many

    @product_category_manager = ProductCategoryManager.new params[:product_category_manager]
    @product_category_manager.join

    render :new_join_many, notice: 'Successfully categorized products'
  end

  private

  def get_categories_names params
   categories = []  
   categories += params[:categories].values  if params[:categories]
   categories << params[:new_category] unless params[:new_category].blank?
   categories
 end


end