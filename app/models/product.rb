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

  has_and_belongs_to_many :sales

  after_create :create_asset
  before_save :save_total_discount

  accepts_nested_attributes_for :assets, :sales

  delegate :rating, to: :reviews

  class << self

    def start_selling
      self.update_all(on_sale: true);
    end

    def on_sale?
      self.where(on_sale: true).count == self.count
    end

    def retire
      self.update_all(on_sale: false)
    end

    def set_discount discount, name=nil
      self.all.each do |product|
        product.set_discount discount, name
      end
    end

    def off_discount identifier=nil
      #identifier - sale obj, name or percent. if nil - every sale
      self.sales.off_discount identifier
    end
  end

  def add param 
    param.each do |name, items|
      self.send "add_#{name}", items
    end
  end

  def start_selling
    self.on_sale = true; self.save
  end

  def retire
    self.on_sale = false; self.save
  end

  def set_discount percent, name=nil
    Sale.attach(self, percent, name); self.save
  end

  def on_discount?
    self.sales.any?
  end

  def off_discount identifier=nil
    Sale.detach(self, identifier)
  end

  def discount
    self.sales.get_discount
  end

  def out_of_stock?
    self.quantity == self.product_users.quantity
  end

  def swap_prepare
    self.quantity +=1
    yield
    self.quantity -=1
  end

  def photos
    Asset.photos_for(self)
  end

  private

  def create_asset
    self.assets.create
  end

  def add_category category
    Category.get(category).add product: self
  end

  def add_review review
    reviews << review
  end

  def add_photos photos
    photos.each do |photo|
      self.assets.create({photo: photo})
    end
  end

  def save_total_discount
    # self.discount= is a column in db, and self.discount is calculated
    self.discount = self.discount || 100
  end
end