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

  def convert prod
    self.product = prod
    self.quantity = ProductUser.quantity(prod, self.order.user)
    self
  end

  def add params
    self.convert(params[:product])
  end

  def subtotal
    self.quantity*self.price
  end
end
