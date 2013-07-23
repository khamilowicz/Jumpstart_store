class User < ActiveRecord::Base

	extend TransferProducts

	has_secure_password

	has_one :address
	accepts_nested_attributes_for :address

	attr_accessible :first_name, :last_name, :email, :password, :password_confirmation, :address_attributes

	validates_format_of :email, with: /\A([^@\s]+)@((?:[-a-z0-9]+\.)+[a-z]{2,})\Z/i, unless: :guest?
	validates_uniqueness_of :email, unless: :guest?
	validates_presence_of :first_name, :last_name, :address, unless: :guest?
	validates :nick, length: {minimum: 2, maximum: 32}, allow_nil: true, unless: :guest?
	validates_presence_of :password, on: :create, unless: :guest?
	validates :password, confirmation: true

	has_many :list_items, as: :holder, include: :product
	has_many :products, through: :list_items
	has_many :orders

	delegate :empty?, to: :cart, prefix: true
	delegate :where_product, to: :list_items

	class << self

		def create_guest
			create do |user_guest|
				user_guest.guest = true
				user_guest.password_digest = 'password'
			end
		end
	end

	def cart
		Cart.new(self)
	end

	%w{add remove}.each do |prefix|
		define_method prefix do |param|
			param.each { |obj_name, object| send "#{prefix}_#{obj_name}", object }
		end
	end

	def promote_to_admin
		self.admin = true
	end

	private

	def add_product product
		self.list_items.add product: product if product.on_sale?
	end

	def remove_product product
		self.list_items.remove product: product 
	end
end