# require "transfer_products"
class Order < ActiveRecord::Base

	belongs_to :user
	has_many :order_products
	monetize :price_cents

	include TransferProducts

	STATUSES = {
		:cancel => 'cancelled',
		:pay => 'paid', 
		:is_sent => 'shipped', 
		:is_returned => 'returned',
		:is_pending => 'pending'
	}

	COMPARISONS = {
		'before' => '<', 'less' => '<',
		'after' => '>', 'more' => '>',
		'at' => '=', 'equal' => '='
	}

	validates_presence_of :user, :address
	validates_inclusion_of :status, in: STATUSES.values

	scope :find_by_status, ->(status){ where(status: status)}
	scope :find_by_email, ->(email){ includes(:user).where(users: {email: email})}
	scope :find_by_date, ->(sign_word, year, month, day){ 
		where("created_at #{COMPARISONS[sign_word]} ?", Date.new(year.to_i,month.to_i,day.to_i)) 
	}
	scope :find_by_value, ->(sign_word, value){ 
		where("price_cents #{COMPARISONS[sign_word]} ?", Money.parse(value).cents)
	}

	def self.count_by_status status;  self.where(status: status).count; end 

	alias_attribute :date_of_purchase, :created_at
	alias_attribute :time_of_status_change, :status_change_date
	alias_attribute :products, :order_products

	before_save :set_price_and_discount

	def self.init user, address
		order = self.new
		order.user = user
		order.set_address address if address
		order
	end

	def set_address address=nil
		self.address = address || self.user.address
	end

	def set_status new_status
		case new_status
		when 'ship' then self.is_sent
		when 'cancel' then self.cancel
		when 'return' then self.is_returned
		end
	end

	def total_price
		self.price != 0 ? self.price*self.discount/100 : sum_price
	end

	def total_price_without_discount
		self.price != 0 ? self.price : sum_price('base')
	end

	def total_discount
		return 100 if total_price_without_discount == 0
		(total_price_without_discount.cents - total_price.cents)*100/total_price_without_discount.cents
	end

	def has_discount?
		self.products.any?(&:on_discount?)
	end

	def transfer_products
		self.set_address unless self.address
		self.save
		super from: self.user, to: self
	end

	STATUSES.each do |method_name, stat|
		define_method method_name do
			self.status = stat
			update_status_date
			save
		end
	end

	def add param
		self.order_products.new.add(param).save if param[:product]
	end

	private

	def set_price_and_discount
		self.price = total_price_without_discount
		self.discount = total_discount if self.has_discount?
	end

	def sum_price price=nil
		self.products.total_price price
	end

	def update_status_date
		self.status_change_date = Time.now
	end
end