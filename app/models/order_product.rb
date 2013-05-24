class OrderProduct < ActiveRecord::Base
  # attr_accessible :order_id, :product_id

  belongs_to :order 
  belongs_to :product

  def method_missing(method, *args, &block)
    if self.product.respond_to?(method)
      self.product.send method, *args, &block
    else
      super
    end
  end

  def self.convert prod, quantity
    op = self.create
    op.product = prod
    op.quantity = quantity
    op
  end
end
