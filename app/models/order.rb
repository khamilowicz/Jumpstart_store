class Order < ActiveRecord::Base

	belongs_to :user
	has_many :order_products

	STATUSES = {
		:cancel => 'cancelled',
		:pay => 'paid', 
		:is_sent => 'shipped', 
		:is_returned => 'returned',
		:is_pending => 'pending'
	}

	validates_presence_of :user, :address, :order_products
	validates_inclusion_of :status, in: STATUSES.values

	scope :all_by_status, ->(status){ where(status: status).all}
	scope :all_by_email, ->(email){ includes(:user).where(users: {email: email}).all}
	def self.count_by_status status;  self.where(status: status).count; end 

	alias_attribute :date_of_purchase, :created_at
	alias_attribute :time_of_status_change, :status_change_date

	class << self
		def statuses
			STATUSES
		end

		def find_by_value sign, value
			value = Money.parse("$#{value}").cents
			orders = Order.all.select do |order|
				case sign
				when 'less' 
					order.total_price.cents < value
				when 'more'
					order.total_price.cents > value
				when 'equal'
					order.total_price.cents == value
				end
			end
			orders
		end

		def find_by_date date, date_value
			date_params = date_value.split(',').map(&:to_i)
			date_parsed = Date.new *date_params
			sign = case date 
			when 'less' then '<'
			when 'more' then '>'
			when 'equal' then '='
			end
			Order.where("created_at #{sign} ?", date_parsed).all
		end

	end

	def set_status new_status
		case new_status
		when 'ship' then self.is_sent
		when 'cancel' then self.cancel
		when 'return' then self.is_returned
		end
	end

	def products
		self.order_products 
	end

	def products= prods
		self.order_products.delete_all

		prods = [prods] unless prods.kind_of?(Array)
		prods.each do |prod|
			op = self.order_products.new
			op.product = prod
		end
	end

	def sum_price price=nil
		self.products.total_price price
	end

	def total_price
		sum_price
	end

	def total_price_without_discount
		sum_price 'base'
	end

	def total_discount
		(total_price_without_discount.cents - total_price.cents)*100/total_price_without_discount.cents
	end

	def has_discount?
		self.products.any?(&:on_discount?)
	end

	def transfer_products 
		self.user.products.all.uniq.each do |product|
			self.add product: product
			self.user.remove product: product
			product.retire
		end
	end
	
	STATUSES.each do |method_name, stat|
		define_method method_name do
			self.status = stat
			update_status_date
			save
		end
	end
	
	def add param
		if param[:product]
			product = param[:product]
			self.order_products << OrderProduct.convert(product, (ProductUser.quantity(product, self.user) || 1))
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
