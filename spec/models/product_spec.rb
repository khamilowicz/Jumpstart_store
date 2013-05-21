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
     @product.price.should be_nil
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
 end

 describe "may have" do
   it "photo. If present it must be a valid URL format." do
     @product.photo.should be_nil 
     @product.should be_valid
     @product.photo = 'shabada'
     @product.should_not be_valid
     @product.photo = 'http://google.pl/image'
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
    @product.should_not be_on_sale
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
    Product.find_on_sale.should_not include(@product)
    @product.start_selling
    @product.save
    Product.find_on_sale.should include(@product)
  end
end

describe "discounts" do
  it "can be discounted" do
   @product.price.should == @product.price_with_discount 
   @product.on_discount 50
   @product.price_with_discount.should == 0.5*@product.price
 end

 it "can be put off discount" do
   @product.price_with_discount.should == @product.price
   @product.on_discount 50
   @product.price_with_discount.should == 0.5*@product.price
   @product.off_discount
   @product.price_with_discount.should == @product.price
 end
end
end
end
end