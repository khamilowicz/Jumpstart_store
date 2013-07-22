class OrderConstructor
	def self.construct user, address
		order = user.orders.build do |ord|
			ord.address = address
		end
		order.transfer_products
		order.pay
		order
	end
end