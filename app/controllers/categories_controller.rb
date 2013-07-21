class CategoriesController < ApplicationController


 def index
 	@categories = Category.all
 end

 def show
  @category = Category.where(id: params[:id]).first

   if @category.nil?
    flash[:errors] = "Category doesn't exist"
    redirect_to categories_path 
  else
   @products = @category.products.page params[:page]
   respond_to do |format|
    format.html { render 'products/index'}
    format.js
  end
end
end
end