require "spec_helper"

describe "search" do
  
 context "finds orders by" do
  it "status" do
   order_pending = FactoryGirl.create(:order, status: 'pending')
   order_cancel = FactoryGirl.create(:order, status: 'cancelled')
   orders = Search.find({status: 'pending'})
   orders.should include(order_pending)
   orders.should_not include(order_cancel)
 end

 it "value" do
  order_over_100 = FactoryGirl.create(:order)
  product_over_100 = FactoryGirl.create(:product, price: 110)
  order_over_100.add product: product_over_100

  order_below_100 = FactoryGirl.create(:order)
  product_below_100 = FactoryGirl.create(:product, price: 90)
  order_below_100.add product: product_below_100

  orders_over = Search.find({value: "more", total_value: "100"})
  orders_below = Search.find({value: "less", total_value: "100"})

  orders_over.should include(order_over_100)
  orders_below.should include(order_below_100)
  orders_over.should_not include(order_below_100)
  orders_below.should_not include(order_over_100)
 end

 it "date" do
  order = FactoryGirl.create(:order)
  order.created_at = Date.new(2010, 10, 10)
  order.save
  orders = Search.find({date: 'less', :'date_value(1i)' => '2011',:'date_value(2i)' => '10',:'date_value(3i)' => '10'})
  orders.should include(order)
 end
end
end