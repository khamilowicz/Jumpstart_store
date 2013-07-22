class Admin::ProductsController < ApplicationController

  before_filter :authorize_admin
  layout 'admin_application'

  def index
    @products = Product.page params[:page]
  end

  def new
    @product = Product.new
  end

  def edit
    @product = Product.find(params[:id])
  end

  def update
    @product = Product.find(params[:id])
    if params[:assets]
      @photos = params[:assets][:photos]
      @product.add photos: @photos
    end

    if @product.update_attributes(params[:product])
      redirect_to admin_products_path, notice: "Successfully updated product"
    else
      redirect_to edit_admin_product_path(@product), notice: "Error"
    end
  end

  def create

    product = Product.new(params[:product])

    product.start_selling

    if product.save
      if params[:assets]
        @photos = params[:assets][:photos]
        product.add photos: @photos
      end
      redirect_to products_path, notice: "Successfully created product"
    else
      redirect_to new_admin_product_path, notice: "Error"
    end
  end

end