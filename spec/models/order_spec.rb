require 'spec_helper'

describe Order do

  context "to be valid" do
    # subject{ FactoryGirl.create(:order)}
    let(:order){ create_order }
    subject{ order}

    it{ should belong_to(:user)}
    it{ should have_many(:order_products)}
    it{ should validate_presence_of(:address)}
    it{ should respond_to(:date_of_purchase) }
    it{ should respond_to(:price)}

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

  describe ".find_by_status" do
   let!(:order_can){ create_order }
   let!(:order_sent){ create_order }

   before do
    order_can.cancel
    order_sent.is_sent
  end

  it{ Order.all.should include(order_can, order_sent)}

  it{
    Order.find_by_status(:shipped).
    should include(order_sent)
  }
  it{
    Order.find_by_status(:shipped).
    should_not include(order_can)
  }
end

describe "total  price and total discount" do
  let(:price){ Money.parse("$1")}
  let(:total_price){ price*3}
  let(:products){FactoryGirl.create_list(:product,3, base_price: price.cents)}
  
  it{ 
    expect{ products.each{|p| p.on_discount 50}}.
    to change{ build_order(products).total_price }.
    from(Money.parse(price*3)).
    to(Money.parse(price*3/2))
  }

  it{ 
    expect{ products.each{|p| p.on_discount 50}}.
    to change{ build_order(products).total_discount}.
    from(0).
    to(50)
  }
  it{ 
    expect{ products.each{|p| p.on_discount 50}}.
    to change{ build_order(products).has_discount?}.
    from(false).
    to(true)
  }
  describe "doesn't change after saving order" do
    before(:each) do
      @order = create_order(products)
      @order.save
    end

    it{
      expect{ products.each{|p| p.on_discount 50}}.
      to_not change{ @order.total_price }
    }

    it{ 
      expect{ products.each{|p| p.on_discount 50}}.
      to_not change{ @order.total_discount}
    }
    it{ 
      expect{ products.each{|p| p.on_discount 50}}.
      to_not change{ @order.has_discount?}
    } 
  end
end

describe "products" do
  let(:user){ FactoryGirl.create(:user)}
  let(:products){ FactoryGirl.create_list(:product, 2, quantity: 3)}
  let(:order){ user.orders.new}
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

    let(:price_10){ Money.parse("$10")}
    let(:price_5){ Money.parse("$5")}

    let(:products_price_10){ FactoryGirl.create_list(:product, 3, base_price: price_10.cents)}
    let(:products_price_5){ FactoryGirl.create_list(:product, 2, base_price: price_5.cents)}

    let(:order_price_30){ create_order products_price_10  }
    let(:order_price_10){ create_order products_price_5  }

    before(:each) do
      order_price_30.save
      order_price_10.save
    end

    it{order_price_30.total_price.should eq(price_10*3)}
    it{order_price_10.total_price.should eq(price_5*2)}

    describe "more" do
      subject{ Order.find_by_value('more', '$20')}

      it{ should include(order_price_30) }
      it{ should_not include(order_price_10) }
    end

    describe "less" do
      subject{ Order.find_by_value('less', '$20')}

      it{ should_not include(order_price_30) }
      it{ should include(order_price_10) }
    end

    describe "equal" do
      subject{ Order.find_by_value('equal', '$10')}

      it{ should_not include(order_price_30) }
      it{ should include(order_price_10) }
    end
  end

  describe ".find_by_date" do
    let(:order_later){ FactoryGirl.create(:order, created_at: Date.new(2010, 10, 11)) }
    let(:order_earlier){ FactoryGirl.create(:order, created_at: Date.new(2008, 10, 10)) }
    subject{ Order.find_by_date('after', "2010", "10", "10") }
    
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

describe ".count_by_status" do
  before(:each) do
    FactoryGirl.create(:order, status: 'pending')
    FactoryGirl.create_list(:order, 2, status: 'cancelled')
  end
  it{ Order.count_by_status('pending').should eq(1)}
  it{ Order.count_by_status('cancelled').should eq(2)}
  
end
end