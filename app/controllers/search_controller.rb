class SearchController < ApplicationController
  def new
    @search = Search.new
  end

  def show
    # binding.pry
    @orders = Search.find(params[:search])
  end
end