class SearchController < ApplicationController
  def new
    @search = Search.new
  end

  def show
    @orders = Search.new(params[:search]).find
  end

  def product
    @products = Product.search_by_title_or_description(params[:search])
    render 'products/list'
  end
end