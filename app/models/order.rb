class Order < ActiveRecord::Base

	belongs_to :user
	has_many :order_products
	# has_many :products, through: :order_products 

	def products
		self.order_products #.collect(&:product)
	end

	def products= prods
		self.order_products.delete_all

		prods = [prods] unless prods.kind_of?(Array)
		prods.each do |prod|
			op = self.order_products.new
			op.product = prod
		end
	end

	# def products<< prods
	# 	prods.each do |prod|
	# 		op = self.order_products.new
	# 		op.product = prod
	# 	end	
	# end

	validates_presence_of :user, :address, :order_products

	# validates_presence_of :user, :products,:address
	scope :all_by_status, lambda{|status| where(status: status).all}

	alias_attribute :date_of_purchase, :created_at
	alias_attribute :time_of_status_change, :status_change_date

	def total_price
		self.products.reduce(0){|sum, product| sum+= product.price}
	end

	def total_discount
		price_without_discount = self.products.reduce(0){|sum, product| sum+= product.base_price}
		100*total_price/price_without_discount
	end

	def transfer_products
		self.user.products.all.uniq.each do |product|
			self.order_products << OrderProduct.convert(product, product.quantity_for(self.user))
			self.user.remove_product product
			product.retire
		end
	end

	def self.statuses
		STATUSES
	end

	STATUSES = {
		:cancel => 'cancelled',
		:pay => 'paid', 
		:is_sent => 'shipped', 
		:is_returned => 'returned'
	}

	def self.find_by_status status
		self.where(status: status).all
	end

	def self.count_by_status status
		self.where(status: status).count
	end

	STATUSES.each do |method_name, stat|
		define_method method_name do
			self.status = stat
			update_status_date
			save
		end
	end

	private
	
	def status= stat
		super
	end

	def update_status_date
		self.status_change_date = Time.now
	end

end
