class ListItem < ActiveRecord::Base

	DiffrentProductAssignment = Class.new(Exception)
	Empty = Class.new(Exception)
	ProductNotPresent = Class.new(Exception)

	belongs_to :product
	belongs_to :holder, polymorphic: true

	validates_numericality_of :quantity, greater_than: 0, only_integer: true
	validates_numericality_of :discount, greater_than: -1, only_integer: true

	scope :where_product, ->(product){ where(product_id: product.id) }

delegate :base_price, to: :product

	def self.quantity_all
		self.sum :quantity
	end

	def self.add params
		list_item = self.where_product(params[:product]).first
			list_item ||= self.new # if there is one, it is increased, if none, new is created
			list_item.add params
			list_item.save
		end

		def self.remove params
			list_item = self.where_product(params[:product]).first
			raise ProductNotPresent unless list_item 
			list_item.remove params
			list_item.save

		rescue Empty
			self.delete list_item
		end

		def remove params
			params.each do |name, object|
				send "remove_#{name}", object
			end
		end

		def add params
			params.each do |name, object|
				send "add_#{name}", object
			end
		end

		def on_discount?
			self.discount > 0
		end

		def self.on_discount?
			self.all.any?{|d| d.on_discount?}
		end

		def self.total_price sth=nil
			self.all.map(&:total_price).reduce(:+) || Money.new(0, 'USD')
		end

		def total_price par=nil
			self.product.base_price*self.quantity*(1 - self.discount/100)
		end

		private

		def remove_product product_x
			raise ProductNotPresent unless self.product == product_x
			self.quantity -= 1
			raise Empty if self.quantity == 0
		end

		def add_product item
			if self.product == nil
				self.product = item
				self.discount = item.discount
			elsif self.product == item
				self.quantity += 1
			else
				raise DiffrentProductAssignment
			end
		end
	end
