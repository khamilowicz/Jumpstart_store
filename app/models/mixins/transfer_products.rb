module TransferProducts

	def transfer_products from_to
		from, to = from_to[:from], from_to[:to]
		from.list_items.update_all(holder_id: to.id, holder_type: to.class.name)
	end
end