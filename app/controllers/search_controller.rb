class SearchController < ApplicationController
  def new
    @search = Search.new
  end

  def show
    @orders = Search.find(Search.new params[:search])
  end
end