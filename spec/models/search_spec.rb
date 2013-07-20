require "spec_helper"

describe "search" do

 context "finds orders by" do
  context "status" do

    let(:order_pending ){ Order.new}
    let(:order_cancel ){ Order.new }
    before(:each) do
      order_cancel.status = 'cancelled'
      order_pending.stub(:valid?){true}
      order_cancel.stub(:valid?){true}
      order_cancel.save
      order_pending.save 
    end

    subject{Search.find(Search.new({status: {status: 'pending'}}))}

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

    def search_find param
      Search.find(Search.new({value: {value: param, total_value: "100"}}))
    end

    it{
      order_over_100.price.should == Money.parse("$110")
      order_below_100.price.should == Money.parse("$90")
      search_find("more").should include(order_over_100)
      search_find("less").should include(order_below_100)
      search_find("more").should_not include(order_below_100)
      search_find("less").should_not include(order_over_100)
    }
  end

  context "date" do
    let(:order){ Order.new}
    before(:each){ 
      order.stub(:valid?){true}; 
      order.created_at = Date.new(2010, 10, 10);
      order.save}
      
      subject{ Search.find( Search.new(
        {date: {
          date: 'before', 
          :'date_value(1i)' => '2011',
          :'date_value(2i)' => '10',
          :'date_value(3i)' => '10'
          }}
          ))
    }
    it{should include(order)}
  end
end
end