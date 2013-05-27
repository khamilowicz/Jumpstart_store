require 'spec_helper'

describe Category do

  describe ".get" do
    before(:each) do
      @name = "Category name"
      @c1 = Category.get @name
    end

    it "creates category by name" do
      @c1.should be_kind_of(Category)
      @c1.name.should == @name
    end

    it "retrieves existing category" do
      c2 = Category.get @name
      c2.should == @c1
      Category.all.should have(1).item
    end
  end

  describe "class.list_categories" do
    it "lists all categories" do
      c1 = Category.get("C_1")
      c2 = Category.get("C_2")
      c3 = Category.get("C_3")
      Category.list_categories.should include(c1,c2,c3)
    end
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

  describe "concerning putting on sale" do

    before(:each) do
      @category_name = "Category_1"
      @product_1 = FactoryGirl.create(:product, :not_on_sale)
      @product_2 = FactoryGirl.create(:product, :not_on_sale)
      @product_3 = FactoryGirl.create(:product, :not_on_sale)
      @product_1.add_to_category @category_name
      @product_2.add_to_category @category_name 
      @product_3.add_to_category "Category_2"
      @category = Category.get(@category_name)
    end

    it ".all_on_sale? tells if every product in category is on sale" do
      @category.all_on_sale?.should be_false
      @category.products.each(&:start_selling)
      @category.all_on_sale?.should be_true
      @category.products.first.retire
      @category.all_on_sale?.should be_false
    end

    it ".start_selling affects every product in category" do
      @category.all_on_sale?.should be_false
      @category.start_selling
      @category.all_on_sale?.should be_true
    end
  end

  it "can be discounted" do
    category = Category.get "discount"
    product_1 = FactoryGirl.create(:product,price: 1) 
    product_2 = FactoryGirl.create(:product,price: 2) 
    category.add_product product_1
    category.add_product product_2
    category.total_price.should == 3
    category.discount 50
    category.total_price.should == 1.5
    category.products.each do |product|
      product.discount.should == 50
    end
  end

end