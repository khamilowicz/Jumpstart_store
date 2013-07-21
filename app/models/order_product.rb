class OrderProduct < ActiveRecord::Base

  belongs_to :order 
  belongs_to :product

  monetize :base_price_cents

  extend TotalPrice

  def method_missing(method, *args, &block)
    if self.product.respond_to?(method)
      self.product.send method, *args, &block
    else
      super
    end
  end

  def respond_to?(method_id, private_methods = false)
    if product.respond_to?(method_id)
      true
    else
      super
    end
  end

  def self.add params
    self.new.add params
  end

  def on_discount?
    self.discount != 100
  end

  def self.on_discount?
    self.minimum(:discount) != 100
  end

  def add product self.product = product self.base_price = product.base_price
    self.discount = product.get_discount
    self.quantity = ProductUser.quantity(product, self.order.user)
    self
  end

  def subtotal
    self.quantity*self.price
  end
end
