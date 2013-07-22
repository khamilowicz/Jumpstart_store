class SearchController < ApplicationController
  def new
    @search = Search.new
  end

  def show
    @orders = Search.new(params[:search]).find
  end
end