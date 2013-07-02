require 'spec_helper'

describe Order do
  context "to be valid" do
    subject{ FactoryGirl.create(:order)}

    it{ should belong_to(:user)}
    it{ should have_many(:order_products)}
    it{ should validate_presence_of(:address)}
    it{ should respond_to(:date_of_purchase) }

    %w{pending cancelled paid shipped returned}.each do |status|
      it{ should allow_value(status).for(:status)}
      it{ should_not allow_value(status + 'not').for(:status)}
    end

    describe "has date of status change" do
      let!(:time_now){ Time.now}
      before do
        Time.stub!(:now).and_return(time_now)
        subject.cancel
      end
      it{ subject.time_of_status_change.should eq(time_now)}
    end
  end

  describe ".all_by_status" do
   let(:order_can){ FactoryGirl.create(:order) }
   let(:order_sent){ FactoryGirl.create(:order) }

   before do
    order_can.cancel
    order_sent.is_sent
  end

  it{
    Order.all_by_status(:shipped).
    should include(order_sent)
  }
  it{
    Order.all_by_status(:shipped).
    should_not include(order_can)
  }
end

describe "total  price and total discount" do
  subject{ Order.new }
  let(:products){FactoryGirl.create_list(:product,3, price: 1)}
  before do
    subject.products = products
  end

  it{ subject.total_price.should eq(3)}

  it{ 
    expect{ products.each{|p| p.on_discount 50}}.
    to change{ subject.total_price}.
    from(3).
    to(1.5)
  }
  it{ 
    expect{ products.each{|p| p.on_discount 50}}.
    to change{ subject.total_discount}.
    from(0).
    to(50)
  }
  it{ 
    expect{ products.each{|p| p.on_discount 50}}.
    to change{ subject.has_discount?}.
    from(false).
    to(true)
  }
end

describe "products" do
  let(:user){ FactoryGirl.create(:user)}
  let(:products){ FactoryGirl.create_list(:product, 2, quantity: 3)}
  let(:order){ user.orders.create}
  let(:product){products.first}
  before { products.each {|product| user.add product: product} }

  describe "transfer" do
    before { order.transfer_products}
    subject{ order.products.first}

    it{ user.products.should be_empty}
    it{ order.products.map(&:title).should include(product.title)}

    it{ should be_kind_of(OrderProduct)}
    its(:quantity){should_not eq(3)}
    its(:quantity){should eq(1)}
  end
end

context "searching" do
  describe ".find_by_value" do

    let(:products_price_10){ FactoryGirl.create_list(:product, 3, price: 10)}
    let(:products_price_5){ FactoryGirl.create_list(:product, 2, price: 5)}
    let(:order_price_30){ FactoryGirl.create(:order) }
    let(:order_price_10){ FactoryGirl.create(:order) }

    before do
      products_price_10.each do |product|
        order_price_30.add product: product
      end
      products_price_5.each do |product|
        order_price_10.add product: product
      end
    end

    it{order_price_30.total_price.should eq(30)}
    it{order_price_10.total_price.should eq(10)}

    describe "more" do
      subject{ Order.find_by_value('more', '20')}

      it{ should include(order_price_30) }
      it{ should_not include(order_price_10) }
    end

    describe "less" do
      subject{ Order.find_by_value('less', '20')}

      it{ should_not include(order_price_30) }
      it{ should include(order_price_10) }
    end

    describe "equal" do
      subject{ Order.find_by_value('equal', '10')}

      it{ should_not include(order_price_30) }
      it{ should include(order_price_10) }
    end
  end

  describe ".find_by_date" do
    let(:order_later){ FactoryGirl.create(:order, created_at: Date.new(2010, 10, 11)) }
    let(:order_earlier){ FactoryGirl.create(:order, created_at: Date.new(2008, 10, 10)) }
    subject{ Order.find_by_date 'more', "2010, 10, 10" }
    
    it{should include(order_later)}
    it{should_not include(order_earlier)}
  end

  describe ".find_by_email" do
    let(:user){ FactoryGirl.create(:user) }
    let(:user_2){ FactoryGirl.create(:user) }
    let(:order){ FactoryGirl.create(:order) }
    let(:order_2){ FactoryGirl.create(:order) }

    before do
      user.orders << order
      user_2.orders << order_2
    end

    subject{ Order.find_by_email(user.email)}
    it{ should include(order)}
    it{ should_not include(order_2)}
  end
end
end