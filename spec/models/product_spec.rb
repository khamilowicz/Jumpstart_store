require 'spec_helper'

describe Product do

	context "to be valid" do
    before(:each) do
      @product = FactoryGirl.create(:product)     
    end

    context "must have" do 

      it "a title" do
        @product.title = ''
        @product.should_not be_valid
        @product.title = 'Product title'
        @product.should be_valid
      end

      it "description" do 
       @product.description = ''
       @product.should_not be_valid
       @product.description = 'Product description'
       @product.should be_valid
     end

     it "price" do
      @product.should_not be_nil

     end


    it "unique title" do
      product_2 = FactoryGirl.build(:product, title: @product.title)
      product_2.should_not be_valid
      product_2.title = "Product 2"
      product_2.should be_valid
    end


    it "price which is a valid decimal numeric value and greater than zero" do
     @product.price = nil
     @product.price.should == 0.0
     @product.should_not be_valid
     @product.price = 'shabada'
     @product.should_not be_valid
     @product.price = 19.432
     @product.should_not be_valid
     @product.price = -10.01
     @product.should_not be_valid
     @product.price = 19.43
     @product.price.should == 19.43
     @product.should be_valid
   end

   it "quantity, which is by default 1" do
    @product.quantity = nil
    @product.should be_valid
    @product.quantity = -2
    @product.should_not be_valid
    @product.quantity = 2.3
    @product.quantity.should == 2
    @product.quantity = 2
    @product.should be_valid
  end
end

context "concerning categories" do
  describe ".add_to_category" do
    it "can take category name" do
      @product.add_to_category "Category_1"
      @product.list_categories.should include("Category_1")
    end

  end

  describe ".list_categories" do
    it "gets only names of categories the product belongs to" do
      @product.add_to_category "Category_1"
      category_2 = Category.get_by_name "Category_2"
      @product.list_categories.should include("Category_1")
      @product.list_categories.should_not include("Category_2")
    end
  end

end

context "concerning reviews" do
  describe "reviews" do
    before(:each) do
      @review_1 = FactoryGirl.build(:review, note: 5)
      @review_2 = FactoryGirl.build(:review, note: 1)
    end

    it "has reviews" do
     @product.add_review @review_1
     @product.reviews.should include(@review_1)
   end

   it "has raiting, based on reviews" do
    @product.rating.should == 0

    @product.add_review @review_1
    @product.rating.should == 5

    @product.add_review @review_2
    @product.rating.should == 3
  end

  it "rating can only by integer or half" do
   @product.add_review @review_1
   @product.add_review @review_1
   @product.add_review @review_2
   @product.rating.should == 3.5
 end
end

describe ".on_sale" do
  it "by default is not on sale" do
    product = Product.new
    product.should_not be_on_sale
  end

  it "can be set to sale" do
    @product.start_selling
    @product.should be_on_sale
  end

  it "can be retired from selling" do
    @product.start_selling
    @product.retire
    @product.should_not be_on_sale
  end

  it "can be found by sale status" do
    @product.retire
    @product.save
    Product.find_on_sale.should_not include(@product)
    @product.start_selling
    @product.save
    Product.find_on_sale.should include(@product)
  end
end

describe "discounts" do
  it "can be discounted" do
   @product.price.should == @product.base_price
   @product.on_discount 50
   @product.price.should == 0.5*@product.base_price
 end

 it "can be put off discount" do
   @product.price.should == @product.base_price
   @product.on_discount 50
   @product.price.should == 0.5*@product.base_price
   @product.off_discount
   @product.price.should == @product.base_price
 end
end

# describe ".in_cart?" do
#   it "tells if product is in user's cart" do
#     user = FactoryGirl.create(:user)
# user_2 = FactoryGirl.create(jjjj:user)
#     product = FactoryGirl.create(:product, :on_sale)
#     user.add_product product
# product.in_cart?(user).should be_true
# product.in_cart?(user_2).should be_false

end
end

describe ".users" do
  it "show users having it in theirs carts" do
    product = FactoryGirl.create(:product, :on_sale)
    user = FactoryGirl.create(:user)
    user.add_product product
    product.users.first.should == user
  end
end

describe ".title_param" do
  it 'returns title as param string' do
    product = FactoryGirl.build(:product, title: "this is product")
    product.title_param.should == 'this-is-product'
  end
end

describe ".quantity_for" do
  it "returns quantity of product for given user" do
    product = FactoryGirl.create(:product, :on_sale, quantity: 3)
    user = FactoryGirl.create(:user)
    product.quantity_for(user).should == 0
    user.add_product product
    product.quantity_for(user).should == 1
    user.add_product product
    product.quantity_for(user).should == 2
  end
end
end