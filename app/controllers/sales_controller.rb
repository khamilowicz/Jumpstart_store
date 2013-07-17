class SalesController < ApplicationController

  before_filter :authorize_admin
  
  def new
  end

  def destroy
    @sale = Sale.find(params[:id])
    @sale.remove unless params[:product]
    if params[:product]
      product = Product.find(params[:product])
      @sale.remove product: product 
    end
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

    if @sale.save
      flash[:notice] = "Successfully created sale"
      redirect_to sales_path
    else
      flash[:errors] = "Something went wrong"
      render :new
    end
  end
end