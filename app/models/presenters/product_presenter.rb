  class ProductPresenter

    extend TotalPrice
    
    attr_accessor :product

    def price
      Money.new @product.base_price_cents.to_i*@product.discount/100, @product.base_price_currency
    end

    def initialize product
      @product = product
    end

    def self.new_from_array products
      products.map { |p| self.new p }
    end

    def method_missing(name, *args, &block)
      if @product.respond_to?(name)
        @product.send name, *args, &block
      else
        super
      end
    end

    def respond_to?(method_id, include_private = false)
      if @product.respond_to?(method_id)
        true
      else
        super
      end
    end

    def list_categories
      @product.categories.list_categories 
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

    def quantity_for user
      ProductUser.quantity(@product, user)
    end

    def quantity_in_magazine
      self.quantity - self.product_users.quantity
    end

  end