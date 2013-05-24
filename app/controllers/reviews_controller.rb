class ReviewsController < ApplicationController
  def create
    @product = Product.find(params[:id])
    review  = @product.reviews.new(params[:review])
    review.user = current_user

    if review.save
      redirect_to product_path(@product)
    else
      # binding.pry
      redirect_to products_path, error: review.errors, notice: "Error"
    end
  end
end