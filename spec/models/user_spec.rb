require 'spec_helper'

describe User do
  before(:each) do
    @user = FactoryGirl.build(:user)
  end

  context "to be valid must have" do

    context "email that is" do

      it "in right format" do
        @user.email = 'john.smith@gmail.co.uk'
        @user.should be_valid

        @user.email = 'shabada'
        @user.should_not be_valid
      end

      it "unique" do
        user_2 = FactoryGirl.build(:user, email: @user.email) 
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
      @product = FactoryGirl.build(:product, on_sale: true)
      @product_1 = FactoryGirl.build(:product)
      @product_2 = FactoryGirl.build(:product)
      @product_3 = FactoryGirl.build(:product)
      @user.add_product @product 
    end
    
    describe ".add_product" do
      it "adds product to user" do
        @user.products.should include(@product)
      end

      it "increases quantity of said product in user's products" do
        @user.product_quantity(@product).should == 1
        @user.add_product @product 
        @user.product_quantity(@product).should == 2
      end

      it "cannot add product that is retired" do
        @product_1.should_not be_on_sale
        @user.add_product @product_1
        @user.products.should_not include(@product_1)
      end

    end

    context "which he has" do
      before(:each) do
        @product_1.start_selling
        @product_2.start_selling
       @user.add_product @product_1
       @user.add_product @product_2
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

    describe ".remove_product" do 
      it "removes product from users products" do 
        @user.remove_product @product_1
        @user.products.should_not include(@product_1)
        @user.products.should include(@product_2)
      end

      it "removes product form users cart" do
        @user.remove_product @product_1
        @user.cart.products.should_not include(@product_1)
        @user.cart.products.should include(@product_2)
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
     @user.add_product @product_1
     @user.add_product @product_2
     @user.add_product @product_3
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
    @user.add_product @product_1
    @user.make_purchase
    @user.orders.should have(2).items
    @user.orders.last.products.should_not include(@product_2)
    @user.orders.first.products.should include(@product_2)
    
  end
end
end
context "concerning status" do
  it "by default is guest" do
    @user.should be_guest
  end

  it "can be changed to admin only by admin" do
    @user.should_not be_admin
    @user.promote_to_admin
    @user.should be_admin
  end
end
end