  class ProductPresenter

    extend TotalPrice
    
    attr_accessor :product, :quantity_in_magazine

    def price
      @product.base_price*@product.get_discount/100
    end

    def initialize product, user=nil
      @product = product
      @quantity_for_user = user ? ProductUser.quantity(@product, user) : 0
      @quantity_in_magazine = self.quantity - self.product_users.quantity
      return nil if product == nil
    end

    def self.new_from_array products, user=nil
      products_ids = Array(products).map{ |p| p.id }
      products = Product.includes(:product_users).find(products_ids)
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
      @quantity_for_user
    end

    # def quantity_for user
    #   ProductUser.quantity(@product, user)
    # end

    # def quantity_in_magazine
    #   self.quantity - self.product_users.quantity
    # end
  end