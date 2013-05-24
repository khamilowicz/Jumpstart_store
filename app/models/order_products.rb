class OrderProduct < ActiveRecord::Base
  attr_accessible :order_id, :product_id

  belongs_to :order
  belongs_to :product

  def self.convert prod
    op = self.new
    op.product = prod
    op.save
  end


end
