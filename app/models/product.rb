class Product < ActiveRecord::Base

  extend TotalPrice

  paginates_per 9

  monetize :base_price_cents

  attr_accessible :title, :description, :base_price_cents, :discount, :quantity, :on_sale, :base_price, :price_cents

  validates :title, presence: true, uniqueness: true
  validates_presence_of :description
  validates :base_price_cents, :format => { :with => /^\d+??(?:\.\d{0,2})?$/ }, :numericality => {:greater_than => 0}, presence: true
  validates :quantity, presence: true, numericality: {greater_than_or_equal_to: 0, integer: true}

  scope :find_on_sale, ->{where(on_sale: true)}

  belongs_to :order

  has_many :product_users
  has_many :users, through: :product_users

  has_many :category_products
  has_many :categories, through: :category_products

  has_many :reviews
  has_many :assets

  after_initialize :set_default_discount_value
  after_create :create_asset

  accepts_nested_attributes_for :assets

  delegate :rating, to: :reviews

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

  def start_selling
    self.on_sale = true; self.save
  end

  def retire
    self.on_sale = false; self.save
  end

  def on_discount discount
    self.discount = discount; self.save
  end

  def on_discount?
    discount < 100
  end

  def off_discount
    self.discount = 100; self.save
  end

  def out_of_stock?
    self.quantity == self.product_users.quantity
  end

  def swap_prepare
    self.quantity +=1
    yield
    self.quantity -=1
  end

  private

  def create_asset
    self.assets.create
  end

  def add_to_category category
    Category.get(category).add product: self
  end

  def add_review review
    reviews << review
  end

  def set_default_discount_value
    self.discount ||= 100
  end
end
