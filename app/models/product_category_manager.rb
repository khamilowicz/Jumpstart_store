class ProductCategoryManager
  include ActiveModel::Validations
  include ActiveModel::Conversion
  extend ActiveModel::Naming

  attr_accessor :products_id, :categories_id
  attr_accessor :product, :category

  def initialize params=nil
    if params
      @products_id = params[:product].reject(&:blank?)
      @categories_id = params[:category].reject(&:blank?)
    end
  end

  def products
    Product.find(@products_id)
  end

  def categories
    Category.find(@categories_id)
  end

  def product_size
    @products_id.size
  end

  def empty?
    @products_id.nil? && @categories_id.nil?
  end

  def join
    products.each do |product|
      categories.each do |category|
        category.add product: product
      end
    end
  end

  def persisted?
    false
  end
end