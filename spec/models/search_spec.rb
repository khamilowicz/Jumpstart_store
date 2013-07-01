require "spec_helper"

describe "search" do

 context "finds orders by" do
  context "status" do

    let(:order_pending ){ FactoryGirl.create(:order, status: 'pending')}
    let(:order_cancel){ FactoryGirl.create(:order, status: 'cancelled')}
    subject{Search.find({status: 'pending'})}

    it{ should include(order_pending)}
    it{ should_not include(order_cancel)}
  end

  context "value" do

    let(:product_over_100){ FactoryGirl.create(:product, price: 110)}
    let(:product_below_100){ FactoryGirl.create(:product, price: 90)}

    let(:order_below_100){ FactoryGirl.create(:order)}
    let(:order_over_100){ FactoryGirl.create(:order)}

    before(:each) do
      order_over_100.add product: product_over_100
      order_below_100.add product: product_below_100
    end

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
      date: 'less', 
      :'date_value(1i)' => '2011',
      :'date_value(2i)' => '10',
      :'date_value(3i)' => '10'
      })
  }
  it{should include(order)}
end
end
end