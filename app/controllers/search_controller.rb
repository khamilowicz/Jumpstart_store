class SearchController < ApplicationController
  def new
    @search = Search.new
  end

  def show
    @orders = Search.find(params[:search])
  end
end