class Sale < ActiveRecord::Base

  has_and_belongs_to_many :products
  has_and_belongs_to_many :categories

  attr_reader :products_id
  attr_accessible :name, :discount

  validates :discount, numericality: {greater_than: 0, less_than: 100 }, presence: true

  class << self

    def new_from_params params
      self.where(name: params[:name_from_select])
      .first_or_initialize
      .construct(params)
    end

    def get_discount
      self.minimum(:discount) || 100
    end

    def attach product, percent, name=nil
      Sale.where(name: name).first_or_create do |dis|
       dis.discount = percent
       dis.name = name
     end.products << product
   end

   def detach product, identifier=nil
    product.sales.get_by_identifier(identifier).destroy_all
  end

  def on_discount percent, name=nil
    self.create( discount: percent, name: name)
  end

  def get_by_identifier identifier
    case identifier.class
    when String then self.where(name: identifier)
    when Fixnum then self.where(discount: identifier)
    else self.scoped
    end
  end
end

def construct params
  sale = Sale.new(
    name: params[:name],
    discount: params[:discount]
    )

  products_id = params[:products] ? params[:products].keys : []

  if params[:categories]
    categories_id = params[:categories].keys
    products_id << CategoryProduct.where(category_id: categories_id).pluck(:product_id)
    sale.categories << Category.find(categories_id) 
  end

  sale.products << Product.find(products_id)
  sale.save
  sale
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