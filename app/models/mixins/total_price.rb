module TotalPrice

  def total_price price=nil
    products = :products unless self.name == "Product"
    products = :product if self.name == "OrderProduct"
    if price == 'base'
      Money.new(self.joins(products).sum("base_price_cents"), "USD")
    else
      Money.new(self.joins(products).sum("base_price_cents * discount"), "USD")/100
    end
  end
end