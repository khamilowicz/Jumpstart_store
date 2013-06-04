require 'spec_helper'

describe User do
  before(:each) do
    @user = FactoryGirl.build(:user, :logged)
  end

  context "who is registered" do
    
  context "to be valid must have" do

    it "password confirmation must match password" do
      attrs = FactoryGirl.attributes_for(:user)
      user = User.new(attrs)
     user.should_not be_valid

      attrs[:password] = 'secret'
      attrs[:password_confirmation] = 'nosecret'
      user = User.new(attrs)
      user.should_not be_valid
      attrs[:password] = 'secret'
      attrs[:password_confirmation] = 'secret'
      user = User.new(attrs)
      user.should be_valid
    end

    context "email that is" do

      it "in right format" do
        @user.email = 'john.smith@gmail.co.uk'
        @user.should be_valid

        @user.email = 'shabada'
        @user.should_not be_valid
      end

      it "unique" do
        user_2 = FactoryGirl.build(:user, :logged, email: @user.email) 
        @user.save
        user_2.should_not be_valid
      end
    end

    it "a full name that is not blank" do
      @user.should be_valid
      @user.first_name = ''
      @user.should_not be_valid
      @user.first_name = 'John'
      @user.last_name = ''
      @user.should_not be_valid
      @user.last_name = "Smith"
      @user.full_name.should == 'John Smith'
    end
  end
end

context "who is guest" do

  context "to be valid" do
    it "needs only nick" do
      guest = FactoryGirl.create(:user, :guest)
      guest.first_name = nil
      guest.last_name = nil
      guest.email = nil
      guest.should be_valid
    end
    
  end
end

    it "may optionally provide a display name that must be no less than 2 characters long and no more than 32" do
      @user.display_name.should == 'John Smith'
      @user.display_name = "Jonesey"
      @user.should be_valid
      @user.display_name = "J"
      @user.should_not be_valid
      @user.display_name = 'A'*33
      @user.should_not be_valid
    end

  context "concerning products" do
    before(:each) do
        @user.save
      @product = FactoryGirl.build(:product, :on_sale, quantity: 2)
      @product_1 = FactoryGirl.build(:product)
      @product_2 = FactoryGirl.build(:product)
      @product_3 = FactoryGirl.build(:product)
      @user.add product: @product 
    end
    
    describe ".add product:" do
      it "adds product to user" do
        @user.products.should include(@product)
      end

      it "increases quantity of said product in user's products" do
        @user.product_quantity(@product).should == 1
        @user.add product: @product 
        @user.product_quantity(@product).should == 2
      end

      it "cannot add product that is retired" do
        @product_1.retire
        @product_1.should_not be_on_sale
        @user.add product: @product_1
        @user.products.should_not include(@product_1)
      end

      it "cannot add products beyond its quantity" do
        product = FactoryGirl.create(:product, :on_sale, quantity: 2)
        user = FactoryGirl.create(:user)
        user.product_quantity(product).should == 0
        user.add product: product
        product.quantity.should == 1
        user.product_quantity(product).should == 1
        user.add product: product
        product.quantity.should == 0
        user.product_quantity(product).should == 2

        user.add product: product
        product.quantity.should == 0
        user.product_quantity(product).should == 2
        
      end

    end

    context "which he has" do
      before(:each) do
        @product_1.start_selling
        @product_2.start_selling
       @user.add product: @product_1
       @user.add product: @product_2
     end

     describe ".products" do
      it "is list of user proudcts" do
        @user.products.should include(@product_1, @product_2)
        @user.products.should_not include(@product_3)
      end
    end

    describe ".cart" do
      it "has only that user's products" do
        @user.cart.products.should include(@product_1, @product_2)
        @user.products.should_not include(@product_3)
      end
    end

    describe ".remove product:" do 
      it "removes product from users products" do 
        @user.remove product: @product_1
        @user.products.should_not include(@product_1)
        @user.products.should include(@product_2)
      end

      it "removes product form users cart" do
        @user.remove product: @product_1
        @user.cart.products.should_not include(@product_1)
        @user.cart.products.should include(@product_2)
      end

      it "returns product to magazine" do
        expect{
          @user.remove product: @product_1
          }.to change{@product_1.quantity}.by(1)
      end
    end
  end

  context "concerning orders" do
    before(:each) do
      @product_1.save
      @product_1.start_selling
      @product_2.save
      @product_2.start_selling
      @product_3.save
      @product_3.start_selling
     @user.add product: @product_1
     @user.add product: @product_2
     @user.add product: @product_3
   end

   it "can purchase products from his cart" do
   
    @user.cart.products.should include(@product_1, @product_2,@product_3)
    @user.orders.should be_empty
    @user.make_purchase
    @user.cart.products.should be_empty
    @user.orders.should have(1).item
    @user.orders.first.should be_kind_of(Order)
  end

  it "can browse previous purchases" do
    @user.make_purchase
    @user.add product: @product_1
    @user.make_purchase
    @user.orders.should have(2).items
    # @user.orders.last.products.should_not include(OrderProduct.convert(@product_2,@product_2.quantity))
    # @user.orders.first.products.should include(OrderProduct.convert(@product_2,@product_2.quantity))
  end
end
end
context "concerning status" do

  it "can be changed to admin only by admin" do
    @user.should_not be_admin
    @user.promote_to_admin
    @user.should be_admin
  end
end
end