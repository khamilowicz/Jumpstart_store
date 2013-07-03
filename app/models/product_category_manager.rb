class ProductCategoryManager
  include ActiveModel::Validations
  include ActiveModel::Conversion
  extend ActiveModel::Naming

  attr_accessor :product, :category

  def initialize params=nil
    super()
    if params
      @product = params[:product].reject(&:blank?)
      @category = params[:category].reject(&:blank?)
    end
  end

  def products
    Product.find(@product)
  end

  def categories
    Category.find(@category)
  end

  def empty?
    @product.nil? && @category.nil?
  end

  def join
    Product.find(product).each do |product|
      Category.find(category).each do |category|
        category.add product: product
      end
    end
  end

  def persisted?
    false
  end

end