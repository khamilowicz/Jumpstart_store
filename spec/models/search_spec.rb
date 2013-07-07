require "spec_helper"

describe "search" do

 context "finds orders by" do
  context "status" do

    let(:order_pending ){ create_order}
    let(:order_cancel){order = create_order; order.cancel; order}
    subject{Search.find({status: 'pending'})}

    it{ should include(order_pending)}
    it{ should_not include(order_cancel)}
  end

  context "value" do

    let(:product_over_100){ FactoryGirl.create(:product, base_price: 11000)}
    let(:product_below_100){ FactoryGirl.create(:product, base_price: 9000)}

    let(:order_over_100){ create_order [product_over_100]}
    let(:order_below_100){ create_order [product_below_100]}

    before(:each) do
      order_below_100.save
      order_over_100.save
    end

it{ order_over_100.price.should == Money.parse("$110")}
it{ order_below_100.price.should == Money.parse("$90")}


    def search_find param
      Search.find({value: param, total_value: "100"})
    end

    it{search_find("more").should include(order_over_100)}
    it{search_find("less").should include(order_below_100)}
    it{search_find("more").should_not include(order_below_100)}
    it{search_find("less").should_not include(order_over_100)}
  end

  context "date" do
    let(:order){ FactoryGirl.create(:order, created_at: Date.new(2010, 10, 10))}
    subject{ Search.find({
      date: 'before', 
      :'date_value(1i)' => '2011',
      :'date_value(2i)' => '10',
      :'date_value(3i)' => '10'
      })
  }
  it{should include(order)}
end
end
end