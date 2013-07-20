require 'spec_helper'

describe Order do

  it{ should belong_to(:user)}
  it{ should have_many(:order_products)}
  it{ should validate_presence_of(:address)}
  it{ should respond_to(:date_of_purchase) }
  it{ should respond_to(:price)}

  %w{pending cancelled paid shipped returned}.each do |status|
    it{ should allow_value(status).for(:status)}
    it{ should_not allow_value(status + 'not').for(:status)}
  end

  context "to be valid" do
    subject{ Order.new }
    before do
      subject.stub(:valid?){true}
    end

    describe "has date of status change" do
      let!(:time_now){ Time.now}
      before do
        Time.stub(:now).and_return(time_now)
        subject.cancel
      end
      it{ subject.time_of_status_change.should eq(time_now)}
    end
  end

  describe ".find_by_status" do
   let!(:order_can){ Order.new }
   let!(:order_sent){ Order.new }

   before do
    order_can.stub(:valid?){true}
    order_sent.stub(:valid?){true}
    order_can.cancel
    order_sent.ship
  end

  it{ Order.all.should include(order_can, order_sent)}

  it{
    found = Order.find_by_status(:shipped)
    found.should include(order_sent)
    found.should_not include(order_can)
  }
end

describe "total  price and total discount" do
  let(:price){ Money.parse("$1")}
  let(:total_price){ price*3}
  let(:products){ []}

  before :each do 
    2.times do 
      product = Product.new
      product.stub(quantity: 2, base_price: price, valid?: true)
      products << product
    end
  end

  it{ 
    expect{ products.each{|p| p.set_discount 50}}.
    to change{ build_order(products).total_price}.
    from(price*2).to(price*2/2)
  }

  it{ 
    expect{ products.each{|p| p.set_discount 50}}.
    to change{ build_order(products).total_discount}.
    from(0).to(50)
  }
  it{ 
    expect{ products.each{|p| p.set_discount 50}}.
    to change{ build_order(products).on_discount?}.
    from(false).to(true)
  }
  describe "doesn't change after saving order" do
    let(:order_saved){create_order products }

    it{
      expect{ products.each{|p| p.set_discount 50}}.
      to_not change{ order_saved.total_price }
    }

    it{ 
      expect{ products.each{|p| p.set_discount 50}}.
      to_not change{ order_saved.total_discount}
    }
    it{ 
      expect{ products.each{|p| p.set_discount 50}}.
      to_not change{ order_saved.on_discount?}
    } 
  end
end

describe "products" do
  let(:user){ FactoryGirl.create(:user)}
  let(:order){ user.orders.new}

  before(:each) do 
   FactoryGirl.create_list(:product, 2).each do |product|
    user.add product: product
  end
end

describe "transfer" do
  before { order.save; order.transfer_products}

  it{ user.products.should be_empty}
  it{ order.products.should_not be_empty}
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

    it{order_price_30.total_price.should eq(price_10*3)
      order_price_10.total_price.should eq(price_5*2)}

      describe "more" do
        subject{ Order.find_by_value('more', '$20')}

        it{ should include(order_price_30)
          should_not include(order_price_10)
        }
      end

      describe "less" do
        subject{ Order.find_by_value('less', '$20')}

        it{ should_not include(order_price_30)
          should include(order_price_10)
        }
      end

      describe "equal" do
        subject{ Order.find_by_value('equal', '$10')}

        it{ should_not include(order_price_30)
          should include(order_price_10) 
        }
      end
    end

    describe ".find_by_date" do
      let(:order_later){ FactoryGirl.create(:order, created_at: Date.new(2010, 10, 11)) }
      let(:order_earlier){ FactoryGirl.create(:order, created_at: Date.new(2008, 10, 10)) }
      subject{ Order.find_by_date('after', "2010", "10", "10") }

      it{
        should include(order_later)
        should_not include(order_earlier)
      }
    end

    describe ".find_by_email" do
      let(:user){ User.new}
      let(:user_2){ User.new }
      let(:order){ FactoryGirl.create(:order) }
      let(:order_2){ FactoryGirl.create(:order) }

      before do
        user.email = "some_email"
        user.stub(:valid? => true)
        user.save
        user_2.email = "other_email"
        user_2.stub(:valid? => true)
        user_2.save

        user.orders << order
        user_2.orders << order_2
      end

      subject{ Order.find_by_email(user.email)}
      it{ should include(order)
        should_not include(order_2)
      }
    end
  end

  describe ".count_by_status" do
    before(:each) do
      order_1 = Order.new
      order_1.stub(valid?: true)
      order_1.save
      2.times do 
      order_2 = Order.new
      order_2.cancel
      order_2.stub(valid?: true)
      order_2.save
    end
      # FactoryGirl.create(:order, status: 'pending')
      # FactoryGirl.create_list(:order, 2, status: 'cancelled')
    end
    it{ Order.count_by_status('pending').should eq(1)
      Order.count_by_status('cancelled').should eq(2)
    }
  end
end