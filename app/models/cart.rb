class Cart

  def initialize user
    @user = user
  end

  def currency
    self.total_price.currency.iso_code
  end

  def empty?
    not products.any?
  end

  def products
    @user.products
  end

  def total_price
    @user.products.total_price
  end
end
