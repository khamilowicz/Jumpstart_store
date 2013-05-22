class User < ActiveRecord::Base

	
	validates_format_of :email, with: /\A([^@\s]+)@((?:[-a-z0-9]+\.)+[a-z]{2,})\Z/i, unless: :guest?
	validates_uniqueness_of :email, unless: :guest?
	validates_presence_of :first_name, :last_name, unless: :guest?
	validates :nick, length: {minimum: 2, maximum: 32}, allow_nil: true, unless: :guest?

	has_many :product_users
	has_many :products, through: :product_users
	has_many :orders
	has_one :cart

	after_create :create_cart

	def guest?
		self.guest
	end

	def self.create_guest
		user = User.create
	end

	def find_by_product product
		self.products.where(id: product.id)
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
		if product.on_sale? && product.quantity > 0
			pu = self.product_users.new
			pu.product = product
			pu.save
		end
	end	

	def product_quantity product
		find_by_product(product).count
	end

	def remove_product product
		products.delete product
	end

	def make_purchase
		orders.create.products = self.cart.products
		self.products.clear
	end

	def promote_to_admin
		self.admin = true
	end

end
