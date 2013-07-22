class Sale < ActiveRecord::Base

  has_and_belongs_to_many :products
  has_and_belongs_to_many :categories

  attr_accessible :name, :discount

  validates :discount, numericality: {greater_than: 0, less_than: 100 }, presence: true

  class << self

    def new_from_params params
      sale = self.where(name: params[:name_from_select])
      .first_or_initialize

      sale.discount = params[:discount] if sale.new_record?

      products_id = params[:products] ? params[:products].keys : []

      if params[:categories].presence
        categories_id = params[:categories].keys
        products_id << CategoryProduct.where(category_id: categories_id).pluck(:product_id)
        sale.categories << Category.find(categories_id)
      end

      sale.products << Product.find(products_id)
      sale.name = params[:name] unless params[:name].blank?
      sale.save
      sale
    end

    def get_discount
      self.minimum(:discount) || 100
    end

    def set_discount percent, name=nil
      self.create(discount: percent, name: name)
    end

    def get_by_identifier identifier
      case identifier.class
      when String then self.where(name: identifier)
      when Fixnum then self.where(discount: identifier)
      else self.scoped
      end
    end
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