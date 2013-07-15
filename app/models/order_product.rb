class OrderProduct < ActiveRecord::Base

  belongs_to :order 
  belongs_to :product

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

  def add product 
    self.product = product
    self.quantity = ProductUser.quantity(product, self.order.user)
    self
  end

  def subtotal
    self.quantity*self.price
  end
end
