class ProductPresenter

  attr_accessor :product

  def initialize product
    @product = product
  end

  def list_categories
    Category.list_categories @product
  end

  def to_param
    @product.to_param
  end

  def method_missing name, *args, &block
    if @product.respond_to?(name.to_sym)
      @product.send name, *args, &block
    else
      super
    end
  end
end