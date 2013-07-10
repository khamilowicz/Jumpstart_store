class Sale < ActiveRecord::Base

  has_and_belongs_to_many :products
  has_and_belongs_to_many :categories

  attr_reader :products_id
  attr_accessible :name, :discount

  validates_numericality_of :discount, greater_than: 0, less_than: 100
  validates_presence_of :discount

  def self.new_from_params params
    categories_id = params[:categories].keys if params[:categories]
    products_id = params[:products].keys if params[:products]
    discount = params[:discount].to_i

    dis = self.new.construct( discount, products_id, categories_id)
    dis.save
    dis
  end

  def self.get_discount
    self.maximum(:discount) || 100
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

  def construct discount, products_id, categories_id
    s = Sale.new
    s.name = ''
    s.discount = discount
    s.products << Product.find(products_id) if products_id
    s.categories << Category.find(categories_id) if categories_id
    s.save
    s
  end


end