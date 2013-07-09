class Sale

  def self.products
    Product.where('discount < ?', 100).all
  end

  def initialize params
    @categories = params[:categories]
    @products = params[:products]
    @discount = params[:discount]
  end

  def discount_all
    @categories.to_a.each do |id, _|
      Category.find(id).on_discount @discount
    end
    @products.to_a.each do |id, _|
      Product.find(id).on_discount @discount
    end
  end
end