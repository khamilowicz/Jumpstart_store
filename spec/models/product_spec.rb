require 'spec_helper'

describe Product do

  include MoneyRails::TestHelpers

  it{ should validate_presence_of(:title)}
  it{ should validate_uniqueness_of(:title)}
  it{ should validate_presence_of(:description)}
  it{ should allow_value(1).for(:base_price)}
  it{ should have_and_belong_to_many(:sales)}
  it{ monetize(:base_price).should be_true}
  # it{ should_not allow_value(1.101).for(:base_price)}
  # it{ should_not allow_value(-1).for(:base_price).with_message("base_price_cents must be greater than 0 (-100)")}
  # it{ should_not allow_value('some string').for(:base_price)}
  it{ should_not allow_value(nil).for(:base_price_cents)}
  it{ should respond_to(:quantity)}
  it{ FactoryGirl.create(:product).quantity.should eq(1)}

  let(:product){ FactoryGirl.create(:product)}
  subject{ product}
  describe "assets" do

    its(:assets){ should_not be_empty}
    it{ product.assets.first.should_not be_nil}

    describe "photos" do
      it{should respond_to(:photos)}
      its(:photos){ should have(1).item}
    end
  end

  context "concerning categories" do

    subject { FactoryGirl.create(:product)}

    before(:each) do
      subject.add category: "Category_1"
    end
    describe "#add_to_category" do
      its(:categories){should include(Category.get "Category_1")}
    end

  end

  context "concerning reviews" do

    it{ should have_many(:reviews)}
    it{ should respond_to(:rating)}
    its(:rating){should eq(0)}

    describe "reviews" do
      let(:review_1){FactoryGirl.create(:review, note: 5)}
      let(:review_2){FactoryGirl.create(:review, note: 1)}
      let(:review_3){FactoryGirl.create(:review, note: 5)}

      it{ expect{ subject.add review: review_1}.to change{subject.rating}.from(0).to(5)}
      it{ expect{ subject.add review: review_2; subject.add review: review_1}.to change{subject.rating}.from(0).to(3)}
      it{ expect{ subject.add review: review_1; 
        subject.add review: review_2;
        subject.add review: review_3
        }.to change{subject.rating}.from(0).to(3.5)
      }
    end


    describe ".on_sale" do
      subject{ FactoryGirl.create(:product, on_sale: false)}
      it{ should_not be_on_sale }

      it{ expect{ subject.start_selling}.to change{subject.on_sale?}.from(false).to(true)}
      it{ subject.start_selling; expect{ subject.retire}.to change{subject.on_sale?}.from(true).to(false)}

      describe ".find_on_sale" do
        let(:product){FactoryGirl.create(:product, on_sale: false)}
        subject{Product}

        its(:find_on_sale){ should_not include(product)}
        its(:find_on_sale){ product.start_selling; should include(product)}
      end

      describe "for class" do
        before(:each) do
          FactoryGirl.create_list(:product, 2)
        end
        it{ Product.on_sale?.should be_true}
      end

    end

    describe ".start_selling" do
      before(:each) do
        FactoryGirl.create_list(:product, 2, on_sale: false)
      end
      it{ expect{Product.start_selling}.to change{ Product.on_sale?}.from(false).to(true)}
    end

    describe "discounts" do
      let(:product){FactoryGirl.build(:product)}
      
      it{ expect{product.on_discount 50}.to change{
        product.discount
        }.from(100).to(50)
      }

      it{ expect{product.on_discount 50; product.off_discount}.to_not change{
        product.discount
        }.from(100)
      }

    end

  describe "for class" do
    let(:products){FactoryGirl.create_list(:product, 3)}
    before(:each) do
      products
      Product.limit(2).on_discount 50
    end
    it{ Product.limit(2).all.each{ |p| p.should be_on_discount}}
    it{ Product.last.should_not be_on_discount}
  end
  end
  describe "#users" do


    let(:product){FactoryGirl.create(:product)}
    let(:user){FactoryGirl.create(:user)}
    subject{product}

    its(:users){ should be_empty}
    its(:users){ user.add product: product; should include(user)}
  end

  describe "#total_price" do
    let(:products){ FactoryGirl.create_list(:product, 5, base_price: 1)}
    let(:user){ FactoryGirl.create :user}
    before(:each) do
      products.each do |p|
        user.add product: p
      end
    end
    subject{ user.products}
    its(:total_price){ should eq(Money.new(5, "USD"))}
  end
end