  class ProductPresenter

    # include ActiveModel::Conversion
    extend ActiveModel::Naming

    extend TotalPrice
    
    attr_accessor :product, :quantity_in_warehouse, :quantity_for_user 

    def belongs_to_user?
      @belongs_to_user || @product.users.include?(@user)
    end

    def price
      @product.base_price*@product.get_discount/100
    end

    def currency
      @product.base_price.currency
    end

    def initialize product, user=nil
      @product = product
      @user = user
      @quantity_for_user = ProductUser.quantity(product, @user)
      @quantity_in_warehouse = self.quantity - @product.product_users.quantity
      @belongs_to_user = belongs_to_user?
      return nil if product == nil
    end

    def self.new_from_array products, user=nil
      Array(products).map { |p| self.new p, user }
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
      @product.photos.last
    end

    def title_param
      @product.title.parameterize
    end
    
    def title_shorter
      title = @product.title
      title.length > 25 ? title[0,25] + '...' : title
    end
  end