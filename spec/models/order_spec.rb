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
      @order.products = FactoryGirl.create(:product)
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
  @order.has_discount?.should be_false
  tp = @order.total_price
  products.each{|p| p.on_discount(50) }
  @order.total_price.should == 0.5*tp
  @order.total_discount.should == 50
  @order.has_discount?.should be_true

end

end

describe "transfers product" do

  before(:each) do
   @user = FactoryGirl.create(:user)
   @product = FactoryGirl.create(:product)

   @user.add product: @product

   @order = @user.orders.create
 end

 it "from user" do
   @order.transfer_products
   @user.products.should be_empty
   @order.products.first.title.should == @product.title
 end
 
end

describe ".products" do
  before(:each) do
    user = FactoryGirl.create(:user)
    @products = FactoryGirl.create_list(:product, 2, quantity: 3)
    @products.each do |product|
      user.add product: product
    end
    @order = user.orders.new
    @order.transfer_products
    @order.save
  end
  subject { @order.products.first}
  it{ should be_kind_of(OrderProduct)}
  its(:quantity){should_not == 3}
  its(:quantity){should == 1}
end

context "searching" do
  describe ".find_by_value" do
    before(:each) do

      @order_1 = FactoryGirl.create(:order)
      @order_2 = FactoryGirl.create(:order)
      products_1 = FactoryGirl.create_list(:product, 3, price: 10)
      products_1.each do |product|
        @order_1.add product: product
      end
      products_2 = FactoryGirl.create_list(:product, 2, price: 5)
      products_2.each do |product|
        @order_2.add product: product
      end
    end
    it {@order_2.total_price.should == 10}
    
    it "finds by total price more than" do
      order_over = Order.find_by_value('more', '20')
      order_over.should include(@order_1)
      order_over.should_not include(@order_2)
    end
    it "finds by total price less than" do
      order_over = Order.find_by_value('less', '20')
      order_over.should_not include(@order_1)
      order_over.should include(@order_2)
    end 
    it "finds by total price equal to" do
      order_over = Order.find_by_value('equal', '10')
      order_over.should_not include(@order_1)
      order_over.should include(@order_2)
    end 
  end

  describe ".find_by_date" do
    before(:each) do
      @order_1 = FactoryGirl.create(:order)
      @order_1.created_at = Date.new(2010, 10, 11)
      @order_1.save
      @order_2 = FactoryGirl.create(:order)
      @order_2.created_at = Date.new(2008, 10, 10)
      @order_2.save
    end
    it "finds by date" do
      orders = Order.find_by_date 'more', "2010, 10, 10"
      orders.should include(@order_1)
      orders.should_not include(@order_2)
    end
    
  end

  describe ".find_by_email" do
    before(:each) do
      @user_1 = FactoryGirl.create(:user)
      @order_1 = FactoryGirl.create(:order)
      @user_1.orders << @order_1

      @user_2 = FactoryGirl.create(:user)
      @order_2 = FactoryGirl.create(:order)
      @user_2.orders << @order_2
      
      @orders = Order.find_by_email(@user_1.email)
    end
    it{ @orders.should include(@order_1)}
    it{ @orders.should_not include(@order_2)}
    
  end

end

end

