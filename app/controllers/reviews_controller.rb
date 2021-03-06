class ReviewsController < ApplicationController

 def edit
  @product = Product.find(params[:product_id])
  @review = @product.reviews.find(params[:id])
end

def update
  @product = Product.find(params[:product_id])
  @review = @product.reviews.find(params[:id])

  if @review.update_attributes(params[:review])
    redirect_to product_path(@product), notice: "Successfully updated"
  else
    redirect_to products_path, error: review.errors, notice: "Error"
  end
end

def create
  @product = Product.includes(:reviews, reviews: :user).find(params[:product_id])
  review  = @product.reviews.new(params[:review])
  review.user = current_user

  if review.save
    @product_presenter = ProductPresenter.new @product, current_user
    respond_to do |format|
      format.html { redirect_to @product}
      format.js { render 'update_reviews'}
    end
  else
    redirect_to products_path, error: review.errors, notice: "Error"
  end
end
end