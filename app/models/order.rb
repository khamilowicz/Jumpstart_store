# require "transfer_products"
class Order < ActiveRecord::Base

	belongs_to :user

	has_many :list_items, as: :holder, include: :product
	has_many :products, through: :list_items

	has_one :address
	accepts_nested_attributes_for :address
	monetize :price_cents

	include TransferProducts

	STATUSES = {
		:cancel 		=> 'cancelled',
		:pay 				=> 'paid',
		:ship 			=> 'shipped',
		:return 		=> 'returned',
		:is_pending => 'pending'
	}

	COMPARISONS = {
		'before' 	=> '<', 'less'		=> '<',
		'after' 	=> '>', 'more'	 	=> '>',
		'at' 			=> '=', 'equal' 	=> '='
	}

	validates_presence_of :user, :address
	validates_inclusion_of :status, in: STATUSES.values

	scope :find_by_status, ->(status){ where(status: status)}
	scope :find_by_email, ->(email){ joins(:user).where(users: {email: email})}
	scope :find_by_date, ->(sign_word, year, month, day){
		where("created_at #{COMPARISONS[sign_word]} ?", Date.new(year.to_i,month.to_i,day.to_i))
	}
	scope :find_by_value, ->(sign_word, value){
		where("price_cents #{COMPARISONS[sign_word]} ?", Money.parse(value).cents)
	}

	def self.count_by_status status;  
		self.where(status: status).count; end

	alias_attribute :date_of_purchase, :created_at
	alias_attribute :time_of_status_change, :status_change_date

	delegate :total_price, :on_discount?, :where_product, to: :list_items

	before_save :set_price_and_discount

	def set_address address=nil
		self.address = address || self.user.address
	end

	def set_status new_status
		if STATUSES.keys.include? new_status.to_sym
			send new_status
		end
	end

	def total_discount
		return 0 if total_price_without_discount.cents.zero?
		(total_price_without_discount.cents - total_price.cents)*100/total_price_without_discount.cents
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
		self.list_items.add param
	end

	private

	def total_price_without_discount
		total_price 'base'
	end

	def set_price_and_discount
		self.price = total_price_without_discount
		self.discount = total_discount
	end

	def update_status_date
		self.status_change_date = Time.now
	end
end