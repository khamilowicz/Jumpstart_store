require 'spec_helper'

describe Category do

  let(:name){ "Category name"}
  let!(:category){ Category.get name}
  describe ".get" do

    subject{ category}

    it{ should be_kind_of(Category)}
    its(:name){should eq(name)}

    it{ assert_equal Category.get(name), category}
    it{ expect{ Category.get(name)}.to_not change{Category.all.size}}
  end

  describe "categories" do
   let!(:c1){Category.new name: "C_1"}
   let!(:c2){Category.new name: "C_2"}
   let!(:c3){Category.new name: "C_3"}
   
   before(:each) do 

    c1.stub(:valid?){true}
    c2.stub(:valid?){true}
    c3.stub(:valid?){true}
    c1.save
    c2.save
    c3.save
   end


   describe "class.list_categories" do
    it{ Category.list_categories.should include("C_1, C_2, C_3") }
  end

  let(:product){Product.new}
  before(:each){ product.stub(:valid?){true}}

  describe "add" do

   it {expect{ category.add product: product}.
   to change{ category.products.size}.by(1) }

   context "adds unique products" do
    it { category.add product: product
      expect{ category.add product: product}.
      not_to change{ category.products.size} }
    end

    context "adds many products at a time" do
      let(:other_product){ Product.new}
      before(:each){ other_product.stub(:valid?){ true}}

      it {expect{ category.add product: [product, other_product]}.
      to change{ category.products.size}.by(2) }
    end

  end

  describe "#products" do

    before{ c1.add product: product}
    subject{ c1.products}

    it{ should include(product)}

    describe "finds products by category" do

      let(:product_1){ Product.new}
      let(:product_11){ Product.new}
      let(:product_2){ Product.new}

      before(:each) do
        product_1.stub(:valid?){ true}
        product_11.stub(:valid?){ true}
        product_2.stub(:valid?){ true}

        product_1.add category: "Category_1"
        product_11.add category: "Category_1"
        product_2.add category: "Category_2"
      end

      subject{Category.get("Category_1").products}

      it{ should include(product_1, product_11)}
      it{ should_not include(product_2)}
      it{ Category.get("Category_2").products.should include(product_2)}
    end
  end
end

describe "total price" do

  let!(:category){ Category.get 'total price'}
 
  let!(:product_1){ FactoryGirl.create(:product, base_price: 100)}
  let!(:product_2){ FactoryGirl.create(:product, base_price: 200)}

  it{
   expect{ category.add product: product_1 }.
   to change{ category.total_price}.
   from(0).
   to(1)

   expect{ category.add product: product_2 }.
   to change{ category.total_price}.
   from(1).
   to(3)
 }

end

describe "concerning putting on sale" do

  let(:category_name){ "Category name"}
  let(:category){Category.get(category_name)}
  
  let(:product_price){ Money.parse("$4")}

  before do
    FactoryGirl.create_list(:product, 2, :not_on_sale, base_price: 200).each do |product|
      product.add category: category_name
    end
  end

  subject{ category}

  its(:products){ should_not be_empty}

  its(:on_sale?){ should be_false}
  it{ expect{ category.start_selling}.to change{category.on_sale?}.to(true)}
  
  describe "category products" do
    let(:products){ category.products}
    
    it{ expect{ products.each(&:start_selling)}.to change{category.on_sale?}.to(true)}
    it{ expect{ products.first.start_selling}.to_not change{category.on_sale?}.to(true)}
  end

  describe "set_discount" do
    before {category.start_selling}
    let(:products){ category.products}

    it{ expect{ category.set_discount 50}.to change{category.total_price}.from(product_price).to(product_price/2)}
  end
end
end