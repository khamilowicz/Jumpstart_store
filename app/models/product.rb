class Product < ActiveRecord::Base

  # extend TotalPrice

  CURRENCY = 'USD'
  NO_PRICE = Money.new(0, CURRENCY)
  QUERY_PRICE_WITH_DISCOUNT = 'products.base_price_cents * ( 1.0 - products.discount/100.0)'
  
  def discount_price_calc
    self.base_price*(1 - self.discount/100.0) || NO_PRICE
  end

  paginates_per 9

  monetize :base_price_cents

  attr_accessible :title, :description, :base_price_cents, :discount, :quantity, :on_sale, :base_price, :price_cents

  validates :title, presence: true, uniqueness: true
  validates_presence_of :description
  validates :base_price_cents, :format => { :with => /^\d+??(?:\.\d{0,2})?$/ }, :numericality => {:greater_than => 0}, presence: true
  validates :quantity, presence: true, numericality: {greater_than_or_equal_to: 0, integer: true}

  scope :find_on_sale, ->{where(on_sale: true)}

  belongs_to :order

  has_many :list_items
  has_many :users, through: :list_items, source: :holder, source_type: "User"

  has_many :category_products
  has_many :categories, through: :category_products

  has_many :reviews, order: 'created_at desc'
  has_many :assets

  has_and_belongs_to_many :sales

  after_create :create_asset
  before_save :save_total_discount

  accepts_nested_attributes_for :assets, :sales

  delegate :rating, to: :reviews
  delegate :get_discount, to: :sales
  delegate :photos, to: :assets
  delegate :quantity_all, to: :list_items

  include PgSearch
  pg_search_scope :search_by_title_or_description, against: [:title, :description]

  class << self

    def start_selling
      update_all(on_sale: true);
    end

    def on_sale?
      where(on_sale: true).count == count
    end

    def retire
      update_all(on_sale: false)
    end

    def set_discount discount, name=nil
      all.each do |product|
        product.set_discount discount, name
      end
    end

    def total_price par=nil
      # all.reduce(NO_PRICE){|sum, p| sum += p.total_price par} 
      Money.new(sum(QUERY_PRICE_WITH_DISCOUNT), CURRENCY)
    end

    def get_discount
      all.map{|product| product.get_discount }.max
    end
  end

  def total_price par=nil
   return base_price || NO_PRICE if par == 'base'
   return discount_price_calc
 end

 def add param
  param.each do |name, items|
    send "add_#{name}", items
  end
end

{'start_selling' => true, 'retire' => false}.each do |name, on_sale_value|
  define_method name do
    self.on_sale = on_sale_value
    save
  end
end

def set_discount percent, name=nil
  sales << Sale.set_discount(percent, name); save
end

def self.on_discount?
  joins(:sales).count > 0
end

def on_discount?
  sales.count > 0
end

def off_discount identifier=nil
  sales.destroy_all; save
end

def out_of_stock?
  quantity == in_carts
end

def in_carts
  list_items.quantity_all
end

def on_sale?
  on_sale && any_left_in_warehouse?
end

def any_left_in_warehouse?
 ListItem.where_product(self).sum(:quantity) < quantity 
end

private

def create_asset
  assets.create
end

def add_category category
  Category.get(category).add product: self
end

def add_review review
  reviews << review
end

def add_photos photos
  photos.each do |photo|
    assets.create({photo: photo})
  end
end

def save_total_discount
  self.discount = get_discount || 0
end
end