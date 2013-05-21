class User < ActiveRecord::Base

	validates_format_of :email, with: /\A([^@\s]+)@((?:[-a-z0-9]+\.)+[a-z]{2,})\Z/i
	validates_uniqueness_of :email
	validates_presence_of :first_name
	validates_presence_of :last_name
	validates :nick, length: {minimum: 2, maximum: 32}, allow_nil: true

	has_many :product_users
	has_many :products, through: :product_users
	has_one :cart
	has_many :orders

	after_create :create_cart


	def find_by_product product
		self.products.where(id: product)
	end

	def full_name
		"#{self.first_name} #{self.last_name}"
	end

	def display_name
		self.nick || full_name
	end

	def display_name= name 
		self.nick = name
	end

	def add_product product
		if product.on_sale?
			pu = self.product_users.new
			pu.product = product
			pu.in_cart = true
			pu.save
		end
	end	

	def product_quantity product
		find_by_product(product.id).count
	end

	def remove_product product
		products.delete product
	end

	def make_purchase
		ord = orders.create
		ord.products += self.cart.products
		self.products = []
	end

	def promote_to_admin
		self.admin = true
	end

end
