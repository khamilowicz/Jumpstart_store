require 'spec_helper'

describe Category do

  describe ".get" do
    let(:name){ "Category name"}
    let!(:category){ Category.get name}

    subject{ category}

    it{ should be_kind_of(Category)}
    its(:name){should eq(name)}

    it{ assert_equal Category.get(name), category}
    it{ expect{ Category.get(name)}.to_not change{Category.all.size}}
  end

  describe "categories" do
   let!(:c1){Category.get("C_1")}
   let!(:c2){Category.get("C_2")}
   let!(:c3){Category.get("C_3")} 

   describe "class.list_categories" do
    it{ Category.list_categories.should include(c1,c2,c3) }
  end

  describe "#products" do

    let(:product){FactoryGirl.create(:product)}
    before{ c1.add product: product}

    subject{ c1.products}

    it{ should include(product)}

    describe "finds products by category" do
      let(:product_1){FactoryGirl.create(:product)}
      let(:product_11){FactoryGirl.create(:product)}
      let(:product_2){FactoryGirl.create(:product)}

      before do
        product_1.add category: "Category_1"
        product_11.add category: "Category_1"
        product_2.add category: "Category_2"
      end

      subject{ Category.find_products_for("Category_1")}

      it{ should include(product_1, product_11)}
      it{ should_not include(product_2)}
      it{ Category.find_products_for("Category_2").should include(product_2)}
    end
  end
end

describe "total price" do


  let!(:category){ Category.get 'total price'}
  let!(:product_1){ FactoryGirl.build(:product, price:'1.00')}
  let!(:product_2){ FactoryGirl.build(:product, price: '2.00')}

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

  before do
    FactoryGirl.create_list(:product, 2, :not_on_sale, price: 2).each do |product|
      product.add category: category_name
    end
  end

  subject{ category}

  its(:products){ should_not be_empty}

  its(:all_on_sale?){ should be_false}
  it{ expect{ category.start_selling}.to change{category.all_on_sale?}.to(true)}
  describe "category products" do
    let(:products){ category.products}
    
    it{ expect{ products.each(&:start_selling)}.to change{category.all_on_sale?}.to(true)}
    it{ expect{ products.first.start_selling}.to_not change{category.all_on_sale?}.to(true)}
  end

  describe "discount" do
    before {category.start_selling}

    it{ expect{ category.discount 50}.to change{category.total_price}.from(4).to(2)}
  end
end
end