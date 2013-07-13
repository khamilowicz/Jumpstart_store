class User < ActiveRecord::Base

	extend TransferProducts

	has_secure_password

	attr_accessible :first_name, :last_name, :email, :password, :address, :password_confirmation
	
	validates_format_of :email, with: /\A([^@\s]+)@((?:[-a-z0-9]+\.)+[a-z]{2,})\Z/i, unless: :guest?
	validates_uniqueness_of :email, unless: :guest?
	validates_presence_of :first_name, :last_name, unless: :guest?
	validates :nick, length: {minimum: 2, maximum: 32}, allow_nil: true, unless: :guest?
	validates_presence_of :password, unless: :guest?
	validates :password, confirmation: true

	has_many :product_users
	has_many :products, through: :product_users
	has_many :orders

	has_one :address

	class << self

		def create_guest
			user_guest = new
			user_guest.guest = true
			user_guest.password_digest = 'lala'
			user_guest.save
			user_guest
		end
	end

	def cart
		Cart.new(self)
	end

	def add param
		add_product param[:product]	if param[:product]
	end

	def remove param
		remove_product param[:product]	if param[:product]
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
