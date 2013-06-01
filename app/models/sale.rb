class Sale

  def self.build params
    @@categories, @@products, @@discount = params[:categories], params[:products], params[:discount].to_i
  end

  def self.discount_all
    @@categories.to_a.each do |id, _|
      Category.find(id).discount @@discount
    end
    @@products.to_a.each do |id, _|
      Product.find(id).on_discount @@discount
    end
  end
end