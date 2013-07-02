require 'spec_helper'

describe Product do

  it{ should validate_presence_of(:title)}
  it{ should validate_uniqueness_of(:title)}
  it{ should validate_presence_of(:description)}
  it{ should allow_value(1).for(:base_price)}
  it{ should_not allow_value(1.101).for(:base_price)}
  it{ should_not allow_value(-1).for(:base_price)}
  it{ should_not allow_value('some string').for(:base_price)}
  it{ should_not allow_value(nil).for(:base_price)}
  it{ should respond_to(:price)}
  it{ should respond_to(:quantity)}
  it{ FactoryGirl.create(:product).quantity.should eq(1)}

  context "concerning categories" do

    subject { FactoryGirl.create(:product)}

    before(:each) do
      subject.add category: "Category_1"
    end
    describe "#add_to_category" do
      its(:list_categories){should include("Category_1")}
    end

    describe "#list_categories" do
      before(:each) do
        Category.get_by_name "Category_2"
      end
      its(:list_categories){should include("Category_1")}
      its(:list_categories){should_not include("Category_2")}
    end
  end

  context "concerning reviews" do

    it{ should have_many(:reviews)}
    it{ should respond_to(:rating)}
    its(:rating){should eq(0)}

    describe "reviews" do
      let(:review_1){FactoryGirl.build(:review, note: 5)}
      let(:review_2){FactoryGirl.build(:review, note: 1)}

      it{ expect{ subject.add review: review_1}.to change{subject.rating}.from(0).to(5)}
      it{ expect{ subject.add review: review_2; subject.add review: review_1}.to change{subject.rating}.from(0).to(3)}
      it{ expect{ subject.add review: review_1; 
        subject.add review: review_2;
        subject.add review: review_1
        }.to change{subject.rating}.from(0).to(3.5)
      }
    end


    describe ".on_sale" do
      it{ should_not be_on_sale }

      it{ expect{ subject.start_selling}.to change{subject.on_sale?}.from(false).to(true)}
      it{ subject.start_selling; expect{ subject.retire}.to change{subject.on_sale?}.from(true).to(false)}

      describe ".find_on_sale" do
        let(:product){FactoryGirl.create(:product, on_sale: false)}
        subject{Product}

        its(:find_on_sale){ should_not include(product)}
        its(:find_on_sale){ product.start_selling; should include(product)}
      end

    end

    describe "discounts" do
      let(:product){FactoryGirl.build(:product)}
      it{ expect{product.on_discount 50}.to change{
        product.price
        }.from(product.base_price).to(0.5*product.base_price)
      }

      it{ expect{product.on_discount 50; product.off_discount}.to_not change{
        product.price
        }.from(product.base_price).to(0.5*product.base_price)
      }

    end
  end
end

describe "#users" do

  let(:product){FactoryGirl.create(:product)}
  let(:user){FactoryGirl.create(:user)}
  subject{product}

  its(:users){ should be_empty}
  its(:users){ user.add product: product; should include(user)}
end

describe "#title_param" do
  subject{ FactoryGirl.build(:product, title: "this is product")}
  its(:title_param) {should eq('this-is-product') }
end

describe "#quantity_for" do
  let(:product){ FactoryGirl.create(:product, quantity: 3) }
  let(:user){ FactoryGirl.create(:user)}

  it{ expect{user.add product: product}.to change{product.quantity_for(user)}.from(0).to(1)}
end

describe "#search" do
  let(:product_searched){FactoryGirl.create(:product, description: "Some text")}
  let(:product_not_searched){FactoryGirl.create(:product, description: "Other text")}
  subject{ Product.search("Some", load: true) }

  its(:results){ should include(product_searched)}
  its(:results){ should_not include(product_not_searched)}
end