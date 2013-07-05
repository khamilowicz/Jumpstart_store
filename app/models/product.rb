class Product < ActiveRecord::Base

  paginates_per 9

  monetize :base_price_cents
  monetize :price_cents

  attr_accessible :title, :description, :base_price_cents, :discount, :quantity, :on_sale, :price_cents, :base_price

  validates :title, presence: true, uniqueness: true
  
  validates_presence_of :description

  validates_presence_of :base_price
  validates :base_price_cents, :format => { :with => /^\d+??(?:\.\d{0,2})?$/ }, :numericality => {:greater_than => 0}

  validates :quantity, presence: true, numericality: {greater_than_or_equal_to: 0, integer: true}

  scope :find_on_sale, ->{where(on_sale: true)}

  has_many :product_users
  has_many :users, through: :product_users
  belongs_to :order
  has_many :category_products
  has_many :categories, through: :category_products
  has_many :reviews

  has_many :assets

  after_create :create_asset
  accepts_nested_attributes_for :assets

  def self.total_price products, price=:price 
    products.reduce(Money.new(0, "USD")){ |sum, product| sum += product.send price}
  end

  def photo
    self.assets.first.photo
  end

  def photos
    Asset.photos_for(self)
  end

  def add param 
    add_review param[:review] if param[:review]
    add_to_category param[:category] if param[:category]
  end

  def rating
    self.reviews.rating
  end

  def start_selling
   self.on_sale = true
   self.save
 end

 def retire
   self.on_sale = false
   self.save
 end

 def price_cents
  return self.base_price_cents*self.discount/100
end

def base_price_cents
  super || Money.new(0, "USD")
end

def discount
  super || 0
end

def on_discount discount
 self.discount = discount
 self.save
end

def on_discount?
  discount < 100
end

def off_discount
 self.discount = 100
 self.save
end

def title_param
  self.title.parameterize
end

def title_shorter
  self.title.length > 25 ? self.title[0,25] + '...' : self.title
end

def quantity_for user
  ProductUser.quantity(self, user)
  # self.users.where(id: user.id).count
end

def out_of_stock?
  self.quantity == self.product_users.quantity
  # in_carts = self.product_users.all.reduce(0){|sum, pu| sum+=pu.quantity }
  # return(super - in_carts)
end

def quantity_in_magazine
  self.quantity - self.product_users.quantity
end

private

def create_asset
  self.assets.create
end

def add_to_category categories
  categories = names_from_hash(categories) if categories.kind_of?(Hash) 
  categories = [categories] unless categories.kind_of?(Array)

  categories.each do |category|
    Category.get(category).add product: self
  end
end

def add_review review
  reviews << review
end

  def names_from_hash paramHash
    names = []
    names += paramHash[:new_category].split(',')
    names += paramHash[:categories].values if paramHash[:categories]
    names
  end
end