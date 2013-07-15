class ProductUser < ActiveRecord::Base
  # attr_accessible :product_id, :user_id
  belongs_to :user
  belongs_to :product

  after_initialize :set_in_cart_status

  validates_numericality_of :quantity, 
                            only_integer: true, 
                            greater_than_or_equal_to: 1
  validates_presence_of :quantity

  class << self

    def add product, user
      ProductUser.where(product_id: product.id, user_id: user.id)
      .first_or_initialize
      .add(product: product)
      .save
    end

    def remove product, user
      pu = ProductUser.where(product_id: product.id, user_id: user.id)
      .first.remove
      pu.empty? ? pu.delete : pu.save
    end

    def quantity_all
      self.sum :quantity
    end

    def quantity product=nil, user=nil
      if product && user
        ProductUser.where(product_id: product.id, user_id: user.id).first.try(:quantity) || 0
      else
        quantity_all
      end 
    end
  end

  def add params
    self.product = params[:product]
    self.quantity += 1 unless self.product.out_of_stock?
    self
  end

  def remove
    self.quantity -= 1 unless empty?
    self
  end

  def empty?
    self.quantity == 0
  end

  private

  def set_in_cart_status
   self.in_cart = true
 end
end
