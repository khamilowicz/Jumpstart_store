require 'spec_helper'

describe Category do

  describe "class.list_categories" do
    it "lists all categories" do
      c1 = Category.get("C_1")
      c2 = Category.get("C_2")
      c3 = Category.get("C_3")
      Category.all_categories.should include(c1)
      Category.all_categories.should include(c2)
      Category.all_categories.should include(c3)
    end
  end

  it "has unique name" do
    category_1 = Category.get("Category_1")
    category_2 = Category.get("Category_1")
    category_1.should eql(category_2)
    Category.list_categories.should have(1).item
  end

  it "can have associated products" do
    c1 = Category.get("Category_1")
product = FactoryGirl.create(:product, on_sale: true)    
    c1.add_product product
    c1.products.should include(product)
  end

  it "finds products by category" do
    product_1 = FactoryGirl.create(:product)
    product_2 = FactoryGirl.create(:product)
    product_3 = FactoryGirl.create(:product)
    product_1.add_to_category "Category_1"
    product_2.add_to_category "Category_1"
    product_3.add_to_category "Category_2"

    products_c_1 = Category.find_products_for("Category_1")
    
    products_c_1.should include(product_1,product_2)
    products_c_1.should_not include(product_3)
    Category.find_products_for("Category_2").should include(product_3)
  end

  it "has total price" do

    category = Category.get 'total price'
    product_1 = FactoryGirl.build(:product, price:'1.00')
    product_2 = FactoryGirl.build(:product, price: '2.00')
    category.add_product product_1
    category.add_product product_2
    category.total_price.should eql(3.00)
    
  end

  it "can be put on sale" do
    product_1 = FactoryGirl.create(:product)
    product_2 = FactoryGirl.create(:product)
    product_3 = FactoryGirl.create(:product)
    product_1.add_to_category "Category_11"
    product_2.add_to_category "Category_11"
    product_3.add_to_category "Category_2"
    
    category = Category.get "Category_11"
    category.all_on_sale?.should be_false
    category.put_on_sale
    category.all_on_sale?.should be_true
  end

  it "can be discounted" do
    category = Category.get "discount"
    product_1 = Product.new 
    product_1.price = 1
    product_2 = Product.new 
    product_2.price = 2
    category.add_product product_1
    category.add_product product_2
    category.total_price.should == 3
    category.discount 50
    category.total_price.should == 1.5
  end

end