class Type
  include ActiveModel::Validations
  include ActiveModel::Conversion
  extend ActiveModel::Naming

  attr_accessor :products_id, :categories_id
  attr_accessor :product, :category
  attr_accessor :new_category_name


  def initialize params=nil
    if params
      @products_id = get_positive_ids params[:product]
      @categories_id = get_positive_ids params[:category]
      @new_category_name = params[:new_category_name].presence
      new_category if @new_category_name
    end
  end

  def new_category
    category = Category.where(name: @new_category_name).first_or_create
    @categories_id << category.id
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
    products.each {|p| p.categories.destroy_all}
    categories.each do |category|
      category.add product: products
    end
  end

  def persisted?
   false
 end

 private

 def get_positive_ids params
  Hash(params).reject{|id, val| val == '0'}.keys
end
end