module TransferProducts

	def transfer_products from_to
		from, to = from_to[:from], from_to[:to]
		from.list_items.all.each do |li|
			li.holder = to
			li.save
		end
	end
end