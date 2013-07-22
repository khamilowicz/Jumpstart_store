require 'spec_helper'

describe Product do

  include MoneyRails::TestHelpers

  it{ should validate_presence_of(:title)}
  it{ should validate_uniqueness_of(:title)}
  it{ should validate_presence_of(:description)}
  it{ should allow_value(1).for(:base_price)}
  it{ should have_and_belong_to_many(:sales)}
  it{ monetize(:base_price).should be_true}
  it{ should_not allow_value(nil).for(:base_price_cents)}
  it{ should respond_to(:quantity)}
  it{ Product.new.tap{|p| p.stub(valid?: true)}.quantity.should eq(1)}
  it{ should have_many(:reviews)}
  it{ should respond_to(:rating)}


  describe "existing with" do 
    let(:product){ Product.new.tap{|p| p.stub(valid?: true); p.save}}
    subject{ product}

    context "concerning categories" do

      before(:each) do
        subject.add category: "Category_1"
      end

      describe "#add_to_category" do
        its(:categories){should include(Category.get "Category_1")}
      end

    end

    describe "assets" do

      its(:assets){ should_not be_empty}
      it{ product.assets.first.should_not be_nil}

      describe "photos" do
        it{should respond_to(:photos)}
        its(:photos){ should have(1).item}
      end
    end

    context "concerning reviews" do

      its(:rating){should eq(0)}

      describe "reviews" do
        let(:review_1){Review.new(note: 5 ).tap{|p| p.stub(valid?: true)}}
        let(:review_2){Review.new(note: 1 ).tap{|p| p.stub(valid?: true)}}
        let(:review_3){Review.new(note: 5 ).tap{|p| p.stub(valid?: true)}}

        it{ expect{ 
          subject.add review: review_1}
          .to change{subject.rating}.from(0).to(5)
        }

        it{ expect{ 
          subject.add review: review_2
          subject.add review: review_1}
          .to change{subject.rating}.from(0).to(3)
        }

        it{ expect{ 
          subject.add review: review_1
          subject.add review: review_2
          subject.add review: review_3
          }.to change{subject.rating}.from(0).to(3.5)
        }
      end
    end

    describe ".on_sale" do
      before(:each){ product.on_sale = false}

      it{ should_not be_on_sale }
      it{ expect{ subject.start_selling}.to change{subject.on_sale?}.from(false).to(true)}
      it{ subject.start_selling; expect{ subject.retire}.to change{subject.on_sale?}.from(true).to(false)}

      describe ".find_on_sale" do
        subject{Product}

        before(:each){ product.save}
        its(:find_on_sale){ should_not include(product)}
        its(:find_on_sale){ product.start_selling; should include(product)}
      end

      describe "for class" do
        before(:each) do
          product.destroy
          Product.new.tap{|p| p.stub(valid?: true); p.start_selling}.save
        end
        it{ Product.on_sale?.should be_true}
      end
    end

    describe ".start_selling" do
      before(:each) do
        Product.new.tap{|p| p.stub(valid?: true)}.save
      end
      it{ expect{Product.start_selling}.to change{ Product.on_sale?}.from(false).to(true)}
    end

    describe "discounts" do
      let(:product){FactoryGirl.build(:product)}

      it{ expect{product.set_discount(50)}.to change{
        product.get_discount
        }.from(100).to(50)
      }

      it{ expect{product.set_discount 50; product.off_discount}.to_not change{
        product.get_discount
        }.from(100)
      }

      it{ expect{product.set_discount 50}.to change{
        product.on_discount?
        }.from(false).to(true)}

        describe "#off_discount" do

          before(:each) do
            product.set_discount 50
          end

          it{ 
            expect{ product.off_discount}.
            to change{ product.get_discount}.
            from(50).to(100)
          }
        end

        describe ".off_discount" do
          before(:each) do
            products = FactoryGirl.create_list(:product, 3)
            products.each { |p| p.set_discount 50 }
          end
          it{ pending
            expect{ Product.off_discount}.
            to change{ Product.get_discount }.
            from(50).to(100)
          }
        end
      end

      describe "for class" do
        let(:products){FactoryGirl.create_list(:product, 4)}
        before(:each) do
          products
          Product.limit(2).set_discount 50
        end
        it{ Product.limit(2).all.each{ |p| p.should be_on_discount}}
        it{ Product.last.should_not be_on_discount}
        it{ Product.limit(2).should be_on_discount}
        it{ Product.offset(2).should_not be_on_discount}
      end
    end
    describe "#users" do

      let(:product){FactoryGirl.create(:product)}
      let(:user){ User.new}
      before(:each){ user.stub(:valid?){true}; user.save}
      subject{product}

      its(:users){ should be_empty}
      its(:users){ user.add product: product; should include(user)}
    end

    describe "#total_price" do
      let(:user){ User.new}
      let(:products){ FactoryGirl.create_list(:product, 5, base_price: 1)}
      
      before(:each) do
        user.stub(:valid?){true}
        user.save
        products.each do |p|
          user.add product: p
        end
      end
      subject{ user.products}
      its(:total_price){ should eq(Money.new(5, "USD"))}
    end
  end