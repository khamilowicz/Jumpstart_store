class SalesController < ApplicationController

  before_filter :authorize_admin
  
  def new
  end

  def delete
    @sale = Sale.find(params[:sale])
    @sale.destroy
    @sales = Sale.all

    respond_to do |format|
      format.html {redirect_to sales_url}
      format.js {render :index}
    end
  end

  def index
    @sales = Sale.all
  end

  def create
    @sale = Sale.new_from_params params
    
    redirect_to products_path
  end
end