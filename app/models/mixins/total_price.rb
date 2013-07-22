module TotalPrice

  def total_price price=nil
    if price == 'base'
      Money.new(self.sum("base_price_cents"), "USD")
    else
      Money.new(self.sum("base_price_cents * discount"), "USD")/100
    end
  end
end