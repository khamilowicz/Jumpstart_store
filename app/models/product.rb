class Product < ActiveRecord::Base
  # attr_accessible :title, :body
  validates :title, presence: true, uniqueness: true
  validates_presence_of :description
  validates :price, :format => { :with => /^\d+??(?:\.\d{0,2})?$/ }, :numericality => {:greater_than => 0}
  validates :photo, format: {with: %r{https?://(www\.)?\w+(\.\w+)+} }, allow_nil: true

  scope :find_on_sale, ->{where(on_sale: true)}

  def categories
  	@categories ||= []
  end

  def add_to_category category
  	categories << category
  end

  def list_categories
  	categories.map{|category| category.respond_to?(:name)? category.name : category}
  end

  def add_review review
  	reviews << review
  end

  def reviews
  	@reviews ||= []
  end

  def rating
  	reviews.size > 0 ? calculate_rating : 0
  end

  def start_selling
  	self.on_sale = true
  end

  def retire
  	self.on_sale = false
  end

  def price_with_discount
  	self.price*self.discount.to_f/100.0
  end

  def on_discount discount
  	self.discount = discount
  end

  def off_discount
  	self.discount = 100
  end

  private

  def calculate_rating
  	sum_of_notes = reviews.reduce(0){|sum, review| sum+=review.note}
  	note = sum_of_notes.to_f/reviews.size
  	(2.0*note).round/2.0 # round to 0.5
  end


end
