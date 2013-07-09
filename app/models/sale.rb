class Sale

  def products
    Product.where('discount = ?', @discount).all
  end

  attr_reader :products_id

  def self.products
    Product.where('discount < ?', 100).all
  end

  def initialize params
    @categories_id = params[:categories].keys if params[:categories]
    @products_id = params[:products].keys if params[:products]
    @discount = params[:discount].to_i
  end

  def discount_all
    Product.joins(:categories).where(categories: {id: @categories_id}).on_discount @discount if @categories_id
    Product.where(id: @products_id).on_discount @discount if @products_id
  end
end