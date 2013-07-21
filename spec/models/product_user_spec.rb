require 'spec_helper'

describe ProductUser do

  it{ should respond_to(:quantity)}
  it{ should belong_to(:user)}
  it{ should belong_to(:product)}

  it{ should validate_numericality_of(:quantity)}
  it{ should_not allow_value(-1).for(:quantity)}
  it{ should_not allow_value(0).for(:quantity)}
  it{ should validate_presence_of(:quantity)}

  describe "after initialization" do
    its(:quantity){ should eq(0)}
  end

  let(:product){ Product.new}
  let(:user){ User.new}

  before(:each) do
    product.stub(:quantity){2}
    product.stub(:valid?){true}
    product.save

    user.stub(:valid?){true}
    user.save
  end

  describe ".add" do
    before(:each) do
      ProductUser.add product, user
    end
    subject{ user.products}

    it{should include(product)}
    it{ 
      expect{ ProductUser.add product, user }.
      to change{ user.product_users.first.quantity}.
      from(1).to(2)

      expect{ ProductUser.add product, user }.
      to_not change{ user.product_users.first.quantity}.
      from(2).to(3)
    }
    
  end

  describe ".remove" do
    before(:each) do
      ProductUser.add product, user
      ProductUser.add product, user
    end

    it{ 
      expect{ ProductUser.remove product, user}.
      to change{ user.product_users.first.quantity }.
      from(2).to(1)

      expect{ ProductUser.remove product, user}.
      to change{ user.product_users.first.nil? }.
      from(false).to(true)
    }
    
  end

  describe ".quantity" do
   before(:each) do
    ProductUser.add product, user
  end 

  it {
    expect{ ProductUser.add product, user}.
    to change{ ProductUser.quantity product, user}.
    from(1).to(2)
  }

  describe ".quantity_all" do
    let(:user_2){ User.new}
    let(:product_2){ Product.new}

    before(:each) do
      product_2.stub(:valid?){true}
      product_2.save

      user_2.stub(:valid?){true}
      user.save
    end
    before(:each) do
      ProductUser.add product, user_2
      ProductUser.add product_2, user_2
    end

    it{ ProductUser.quantity_all.should eq(3)}
    it{ product.product_users.quantity_all.should eq(2)}
    it{ product_2.product_users.quantity_all.should eq(1)}

  end
end

describe "#add" do
  context "product" do
    before(:each) do
      subject.add product: product
    end

    its(:product){should eq(product)}
    its(:quantity){should eq(1)}

    it{ 
      expect{ subject.add product: product}.
      to change{ subject.quantity}.
      by(1)
    }
  end
end
describe "#remove" do
  context "product" do

    before(:each) do
      subject.add product: product
      subject.add product: product
      subject.remove 
    end

    its(:quantity){ should eq(1)}
    it{
      expect{ subject.remove}.
      to change{ subject.quantity }.
      from(1).
      to(0)
      expect{ subject.remove}.
      to_not change{ subject.quantity }
    }
  end
end

describe ".total_price" do
  before(:each) do
    @products = FactoryGirl.create_list(:product, 3, base_price: 100)
    @products.each do |product|
      pu = ProductUser.new 
      pu.product = product
      pu.quantity = 1
      pu.save
    end
  end
  it "calculates total price of all product_users" do
    ProductUser.total_price.should eq(Money.new(300, 'USD'))
  end
end
end