require 'spec_helper'

describe Order do
  context "to be valid" do
    before(:each) do
      @order = FactoryGirl.build(:order)
    end

    it "must belong to an user" do
      @order.user = nil
      @order.should_not be_valid
    end
    

    it "is for one or more products currently being sold" do
      @order.products = []
      @order.should_not be_valid
      @order.products << FactoryGirl.create(:product)
      @order.should be_valid
    end

    it "has address" do
      @order.address = nil
      @order.should_not be_valid
      @order.address = "Other address"
      @order.should be_valid
    end

    it "has date of purchase" do
      @order.save
      time = Time.now
      @order.date_of_purchase.to_date.should == time.to_date
    end

    it "has total price" do
      @order.products = FactoryGirl.create_list(:product, 3, price: 1)
      @order.total_price.should == 3
    end

    it 'has status in "pending", "cancelled", "paid", "shipped", "returned")' do
  @order.status.should == "pending"
  @order.should be_valid
  @order.cancel
  @order.status.should == "cancelled"
  @order.should be_valid
  @order.pay
  @order.status.should == "paid"
  @order.should be_valid
  @order.is_sent
  @order.status.should == "shipped"
  @order.should be_valid
  @order.is_returned
  @order.status.should == "returned"
  @order.should be_valid
  expect{@order.status = "cancelled"}.to raise_error
  expect{@order.status = "something else"}.to raise_error
end

it "has date of status change" do
  @time_now = Time.now
  Time.stub!(:now).and_return(@time_now)
  @order.cancel
  @order.time_of_status_change.should == @time_now
end

it "can be found by status" do
  order_can = FactoryGirl.create(:order)
  order_can.cancel
  order_can.save
  order_sent = FactoryGirl.create(:order)
  order_sent.is_sent
  order_sent.save
  Order.all_by_status(:shipped).should include(order_sent)
  Order.all_by_status(:shipped).should_not include(order_can)
end

it "can calculate total discount" do
  products = FactoryGirl.create_list(:product,3, price: 1)
  @order.products = products
  tp = @order.total_price
  products.each{|p| p.on_discount(50) }
  @order.total_price.should == 0.5*tp
  @order.total_discount.should == 50

end

end
it "can transfer products from user" do
  user = FactoryGirl.create(:user)
  product = FactoryGirl.create(:product)

  user.add_product product

  order = user.orders.new
  order.transfer_products
  order.products.should include(product)
  user.products.should be_empty
  
end

end

