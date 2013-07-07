module TransferProducts

  def transfer_products from_to
    from, to = from_to[:from], from_to[:to]

    from.products.all.each do |product|
      product.swap_prepare do
        to.add product: product
        from.remove product: product
      end
    end
  end
end