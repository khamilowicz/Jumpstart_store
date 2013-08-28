  class ProductPresenter

    extend ActiveModel::Naming

    attr_accessor :product, :quantity_in_warehouse, :quantity_for_user
    def belongs_to_user?
      @belongs_to_user || @product.users.include?(@holder)
    end

    def quantity_for_user
      @quantity_for_holder
    end

    def price
      @product.base_price*(1 - @product.get_discount.to_f/100)
    end

    def currency
      @product.base_price.currency
    end

    def quantity
      @quantity_for_holder
    end

    def initialize product, holder=nil
      @product = product
      @holder = holder
      @quantity_for_holder = 0
      @quantity_for_holder = @holder.where_product(@product).quantity_all if @holder
      @quantity_in_warehouse = self.quantity - @product.list_items.quantity_all
      @belongs_to_user = belongs_to_user?
      return nil if product == nil
    end

    def self.new_from_array products, holder=nil
      Array(products).map { |p| self.new p, holder }
    end

    def method_missing(name, *args, &block)
      return @product.send name, *args, &block if @product.respond_to?(name)
      super # otherwise
    end

    def respond_to?(method_id, include_private = false)
      return true if @product.respond_to?(method_id)
      super #otherwise
    end

    def list_categories
      @product.categories.list_categories
    end

    def list_sales_with_discounts
      @product.sales.pluck(:name).zip @product.sales.pluck(:discount)
    end

    def to_param
      @product.to_param
    end

    def photo
      @product.photos.first
    end

    def title_param
      @product.title.parameterize
    end

    def title_shorter
      title = @product.title
      title.length > 25 ? title[0,25] + '...' : title
    end
  end