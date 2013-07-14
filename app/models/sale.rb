class Sale < ActiveRecord::Base

  has_and_belongs_to_many :products
  has_and_belongs_to_many :categories

  attr_reader :products_id
  attr_accessible :name, :discount

  validates_numericality_of :discount, greater_than: 0, less_than: 100
  validates_presence_of :discount

  def self.new_from_params params

    discount = params[:discount].to_i
    categories_id = params[:categories].keys if params[:categories]
    products_id = params[:products].keys if params[:products]
    name = params[:name] if params[:name]

    dis = self.where(name: params[:name_from_select])
    .first_or_initialize
    .construct( discount, name, products_id, categories_id)
    dis.save
    dis
  end

  def self.get_discount
    self.minimum(:discount) || 100
  end

  def self.attach product, percent, name=nil
    if name
      dis = Sale.where(name: name).first_or_initialize
    else
      dis = self.new
    end
    dis.discount = percent
    dis.name = name
    dis.products << product
    dis.save
    dis
  end

  def self.detach product, identifier
    product.sales.delete get_by_identifier(identifier).all
  end

  def self.on_discount percent, name=nil
    dis = self.new
    dis.discount = percent
    dis.name = name
    dis.save
    dis
  end

  def self.get_by_identifier identifier
    discount_o = self.where(id: identifier.id) if identifier.kind_of?(Sale)
    discount_o = self.where(name: identifier) if identifier.kind_of?(String)
    discount_o = self.where(discount: identifier) if identifier.kind_of?(Fixnum)
    discount_o = self.scoped if identifier.nil?
    discount_o
  end

  def construct discount, name, products_id, categories_id
    s = Sale.new
    s.name = name
    s.discount = discount
    if categories_id
      products_id ||= []
      products_id << CategoryProduct.where(category_id: categories_id).pluck(:product_id)
      s.categories << Category.find(categories_id) 
    end
    s.products << Product.find(products_id) if products_id

  s.save
  s
end

def remove params={}
 remove_product params[:product] if params[:product]
 Sale.delete self if params.empty?
end

private

def remove_product product
  self.products.delete product
end
end