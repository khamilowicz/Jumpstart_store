class CategoriesController < ApplicationController

 def index
 	@categories = Category.all
 end

 def show
   @category = Category.find(params[:id])

   respond_to do |format|
    format.html { render :show}
    format.js
  end
end
end