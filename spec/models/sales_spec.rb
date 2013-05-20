require "spec_helper"
# require 'rspec/autorun'
# require_relative '../../app/models/product'
# require_relative '../../app/models/sale'

describe Sale do
  before(:each) do
    @product = Product.new
    @product.price = 10
  end
  describe ".set_discount" do
    it "sets discount rate for given product" do
      @product.price.should == 10.00
      Sale.set_discount(@product, 50)
      @product.price.should == 5.00
    end
  end

  describe ".list_sales" do
    it "returns array of products and discounts" do
      product = Product.new 
      product.price = 20.00
      Sale.set_discount(product, 10)
      Sale.set_discount(@product, 50)
      Sale.list_sales.should include([product, 10], [@product, 50])
    end
  end
end