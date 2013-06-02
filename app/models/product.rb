class Product < ActiveRecord::Base
  # attr_accessible :title, :body


  attr_accessible :title, :description, :base_price, :photo, :discount, :quantity, :on_sale, :price
  validates :title, presence: true, uniqueness: true
  validates_presence_of :description
  validates :base_price, :format => { :with => /^\d+??(?:\.\d{0,2})?$/ }, :numericality => {:greater_than => 0}
  # validates :photo, format: {with: %r{https?://(www\.)?\w+(\.\w+)+} }, allow_nil: true

  validates :quantity, presence: true, numericality: {greater_than_or_equal_to: 0, integer: true}

  scope :find_on_sale, ->{where(on_sale: true)}

  has_many :product_users
  has_many :users, through: :product_users
  belongs_to :order
  has_many :category_products
  has_many :categories, through: :category_products
  has_many :reviews

  has_attached_file :photo

  alias_attribute :price= , :base_price=

  # def in_cart? user
  #   ProductUser.where(user: user.id, product: self.id).first.in_cart?
  # end



  def add param 
    add_review param[:review] if param[:review]
    add_to_category param[:category] if param[:category]
  end

  def list_categories
    categories.map(&:name).join(',')
  end

  def rating
    reviews.empty? ? 0 : calculate_rating
  end

  def start_selling
   self.on_sale = true
 end

 def retire
   self.on_sale = false
 end

 def price
  (self.base_price*self.discount/100.0).round(2)
end

def base_price
 super || 0 
end

def discount
  super || 0
end

def on_discount discount
 self.discount = discount
 self.save
end

def off_discount
 self.discount = 100
 self.save
end

def title_param
  self.title.parameterize
end

def title_shorter
  self.title.length > 35 ? self.title[0,35] + '...' : self.title
end


def quantity_for user
  self.users.where(id: user.id).count
end

def quantity
  in_carts = self.product_users.count
  return(super.to_i - in_carts)
end


private

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

def calculate_rating
 sum_of_notes = reviews.reduce(0){|sum, review| sum+=review.note}
 note = sum_of_notes.to_f/reviews.size
  	(2.0*note).round/2.0 # round to 0.5
  end

  def names_from_hash paramHash
    names = []
    names += paramHash[:new_category].split(',')
    names += paramHash[:categories].values if paramHash[:categories]
    names
  end
end
