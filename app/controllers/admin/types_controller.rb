class Admin::TypesController < ApplicationController

  def new
    @type = Type.new
    @products = Product.all
    @categories = Category.all 
  end

  def create
    @type = Type.new params[:type]
    @type.join

@categories = Category.all
    render 'index', notice: 'Successfully categorized products' 
  end

  def edit
    @type = Type.new
    @products = [Product.find(params[:id])]
    @type.product = @products
    @type.category = @products.map { |p| p.categories.all }.flatten.uniq
    @categories = Category.all
  end

  def update
    @type = Type.new params[:type]
    @type.join

@categories = Category.all
    render 'index', notice: 'Successfully categorized products' 
  end

  def destroy

  end

  private

  def get_categories_names params
    categories = []  
    categories += params[:categories].values  if params[:categories]
    categories << params[:new_category] unless params[:new_category].blank?
    categories
  end
end