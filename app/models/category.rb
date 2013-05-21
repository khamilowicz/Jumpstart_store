class Category < ActiveRecord::Base

	has_many :category_products
	has_many :products, through: :category_products


  # attr_accessible :title, :body
  def self.get_by_name c_name
  	
  end

  def self.find_products_for category_name
  	self.get(category_name).products
  end

  def self.get category_name
  	Category.where(name: category_name).first_or_create do |category|
  		category.name = category_name
  	end
  end

  def self.list_categories
  	self.all
  end


  def add_product product
  	self.products << product
  end

  def total_price
  	
  end

end
