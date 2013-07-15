class Category < ActiveRecord::Base

  attr_accessible :name
  has_many :category_products
  has_many :products, through: :category_products, uniq: true

  has_and_belongs_to_many :sales

  delegate :set_discount, :total_price, :start_selling, :on_sale?, to: :products

  class << self

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
    self.products << param[:product]
  end

  def products_for_user user 
    self.products.joins(:product_users).where(product_users: {user_id: user.id})
  end
end
