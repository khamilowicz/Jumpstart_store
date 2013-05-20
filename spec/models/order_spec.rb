require 'spec_helper'
require "rspec/mocks"

describe Order do
  context "to be valid" do
    before(:each) do
      @user = double("User")
      @user.stub(:address).and_return("Address")
      @product_1 = Product.new 
      @product_1.price = 10.00
      @product_2 = Product.new 
      @product_2.price = 10.00
      @product_3 = Product.new 
      @product_3.price = 10.00
      @products = [@product_1, @product_2, @product_3]
      @time_now = Time.now
      Time.stub!(:now).and_return(@time_now)
      @order = Order.new(@products, @user)
    end

    it "must belong to an user" do
      expect{order = Order.new}.to raise_error
      user = double("User")
      expect{order = Order.new(@products, @user )}.not_to raise_error
    end
    

    it "is for one or more products currently being sold" do
      order = Order.new([], @user)
      expect(order).not_to be_valid 
      order = Order.new(@products, @user)
      order.should be_valid
    end

    it "has address" do
      @order.address.should == 'Address'
      @order.address = "Other address"
      @order.address.should == 'Other address'
    end

    it "has date of purchase" do
      @order.date_of_purchase.should == @time_now
    end

    it "has total price" do
      @products.each.with_index{|product, index| product.stub(:price).and_return(index)}
      @order.total_price.should == 3
    end

    it 'has status in "pending", "cancelled", "paid", "shipped", "returned")' do
  @order.status.should == "pending"
  @order.cancel
  @order.status.should == "cancelled"
  @order.pay
  @order.status.should == "paid"
  @order.is_sent
  @order.status.should == "shipped"
  @order.is_returned
  @order.status.should == "returned"
  expect{@order.status = "cancelled"}.to raise_error
  @order.status.should_not == "cancelled"
  expect{@order.status = "something else"}.to raise_error
  @order.status.should_not == "something else"
end

it "has date of status change" do
  @time_now = Time.now
  Time.stub!(:now).and_return(@time_now)
  @order.cancel
  @order.time_of_status_change.should == @time_now
  
end
it "can be found by status" do
  order_can = Order.new [], double("user")
  order_can.cancel
  order_sent = Order.new [], double("user")
  order_sent.is_sent
  Order.find_by_status(:shipped).should include(order_sent)
  Order.find_by_status(:shipped).should_not include(order_can)
end

it "has products" do
  @order.products.should include(@product_1, @product_2)
end

it "can calculate total discount" do
 tp = @order.total_price 
 Sale.set_discount(@product_1, 50)
 Sale.set_discount(@product_2, 50)
 Sale.set_discount(@product_3, 50)
 @order.total_price.should == 0.5*tp
 @order.total_discount.should == 50

end

end
end

