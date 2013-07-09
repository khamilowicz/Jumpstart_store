class Category < ActiveRecord::Base

  attr_accessible :name
  has_many :category_products
  has_many :products, through: :category_products

  class << self

    def get_by_name name
      self.where(name: name).all
    end

    def find_products_for category_name
     self.get(category_name).products
   end

   def get category_name
     self.where(name: category_name).first_or_create do |category|
      category.name = category_name
    end
  end

  def list_categories
    self.pluck(:name).join(', ')
  end
end

def add param
  add_product param[:product] if param[:product]
end

def products_for_user user 
  self.products.joins(:product_users).where(product_users: {user_id: user.id})
end

def total_price
 self.products.total_price
end

def all_on_sale?
 self.products.all?(&:on_sale?)
end

def start_selling
 self.products.each(&:start_selling)
end

def discount percent
 self.products.each{|product| product.on_discount percent}
end

private 

def add_product product
  self.products << product unless self.products.where(id: product.id).any?
end
end
