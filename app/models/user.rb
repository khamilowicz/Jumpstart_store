class User < ActiveRecord::Base

	attr_accessible :first_name, :last_name, :email, :password, :address, :password_confirmation, :admin
	
	validates_format_of :email, with: /\A([^@\s]+)@((?:[-a-z0-9]+\.)+[a-z]{2,})\Z/i, unless: :guest?
	validates_uniqueness_of :email, unless: :guest?
	validates_presence_of :first_name, :last_name, unless: :guest?
	validates :nick, length: {minimum: 2, maximum: 32}, allow_nil: true, unless: :guest?
	validates_presence_of :password, unless: :guest?
	validates :password, confirmation: true

	has_many :product_users
	has_many :products, through: :product_users
	has_many :orders
	has_one :cart

	after_create :create_cart

	class << self

		def transfer_products from_to
			from_user, to_user = from_to[:from], from_to[:to]
			from_user.products.each do |product|
				from_user.remove product: product
				to_user.add product: product
			end
		end

		def create_guest
			new.make_guest
		end
	end

	def make_guest
		self.guest = true
		self.save
		self
	end

	# def products_uniq 
	# 	products.uniq 
	# end

	def find_by_product product
		self.products.where(id: product.id)
	end

	# def full_name
	# 	"#{self.first_name} #{self.last_name}"
	# end

	# def display_name
	# 	return 'Guest' if guest?
	# 	self.nick || full_name
	# end

	# def display_name= name 
	# 	self.nick = name
	# end

	def add param
		add_product param[:product]	if param[:product]
	end

	def remove param
		remove_product param[:product]	if param[:product]
	end

	def product_quantity product
		ProductUser.quantity(product, self)
	end

	def orders
		admin? ? Order.where("user_id is not NULL") : super
	end

	def make_purchase
		orders.create.products = self.cart.products
		self.products.clear
	end

	def promote_to_admin
		self.admin = true
	end

	private

	def add_product product
		ProductUser.add product, self if product.on_sale?
	end

	def remove_product product
		ProductUser.remove product, self
	end
end
