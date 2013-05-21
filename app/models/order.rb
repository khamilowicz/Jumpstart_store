class Order < ActiveRecord::Base

	belongs_to :user
	has_many :products

	validates_presence_of :user, :products, :address

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

	STATUSES = {
		:cancel => 'cancelled',
		:pay => 'paid', 
		:is_sent => 'shipped', 
		:is_returned => 'returned'
	}

	STATUSES.each do |method_name, stat|
		define_method method_name do
			self.status = stat
			update_status_date
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
