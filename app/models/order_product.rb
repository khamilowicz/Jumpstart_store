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
    n = self.new.add params
    n
  end

  def add params
    self.product = params[:product]
    self.quantity = ProductUser.quantity(params[:product], self.order.user)
    self
  end

  def subtotal
    self.quantity*self.price
  end
end
