class CategoriesController < ApplicationController

 def index
 	@categories = Category.all
 end

 def show
   @category = Category.find(params[:id])
   @products = @category.products.page params[:page]

   respond_to do |format|
    format.html { render 'products/index'}
    format.js
  end
end
end