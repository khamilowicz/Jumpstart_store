class CategoriesController < ApplicationController

 def index
 	@categories = Category.all
 end

 def show
   @category = Category.find(params[:id])
   @products = @category.products.page params[:page]
   @products_presenter = ProductPresenter.new_from_array @category.products

   respond_to do |format|
    format.html { render 'products/index'}
    format.js
  end
end
end