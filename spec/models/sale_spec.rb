require "spec_helper"

describe Sale do
  it{ should respond_to(:discount)}
  it{ should validate_presence_of(:discount)}
  it{ should respond_to(:name)}
  it{ should have_and_belong_to_many(:products)}
  it{ should validate_numericality_of(:discount)}
  it{ should_not allow_value(100).for(:discount)}
  it{ should_not allow_value(0).for(:discount)}

  describe "creation" do

    describe "for product" do

      before(:each) do
        @product = Product.new
        @product.stub(:valid?){ true}
        @product.save
        @product.set_discount 10, 'sale'
      end

      subject{ @product.sales.first}

      it{ @product.sales.should have(1).item}
      its(:name){should eq('sale')}
      its(:discount){should eq(10)}

      describe "#get_discount" do
        it{ @product.sales.get_discount.should eq(10)}
        it{
          expect{@product.set_discount 9}
          .to change{@product.sales.get_discount}
          .from(10).to(9)
        }
        it{
          expect{@product.set_discount 13}
          .to_not change{@product.sales.get_discount}
        }

      end

      describe "and removement" do
        subject{ @product.sales.first}
        it{ expect{
         subject.remove(product: @product); @product.save}.
         to change{ @product.discount}.
         from(10).to(100)
       }
       it{ expect{
        subject.remove }.
        to change{ Sale.where(id: subject.id).first }.
        from(subject).to(nil)
      }
    end
  end

  describe "for category" do
    before(:each) do
      @products = FactoryGirl.create_list(:product, 2)
      @products.each do |product|
        product.add category: "Category one"
      end
      @product_not_in_category = FactoryGirl.create(:product)
      Category.get('Category one').set_discount 50
    end

    it{ @products.each { |product| product.get_discount.should eq(50) }}
    it{ @product_not_in_category.discount.should eq(100)}
  end
end

describe "created from params" do
  let(:products){ FactoryGirl.create_list(:product, 2)}
  context "for products" do

    before(:each) do
      @products_hash = {}
      products.each do |prod|
        @products_hash[prod.id] = ''
      end
    end

    def make_sale
     Sale.new_from_params products: @products_hash, discount: 50 
   end

   it{ make_sale.products.should include(*products)}

   it{
    expect{ make_sale}
    .to change{ Product.all.all?(&:on_discount?)}
    .from(false).to(true)  
  }
  it{
    expect{ make_sale}
    .to change{ products.first.get_discount}
    .from(100).to(50)  
  }
end
end
context "for categories" do
  let(:products){ FactoryGirl.create_list(:product, 2)}
  before(:each) do
    @categories_hash = {}
    products.first.add category: "Category one"
    @categories_hash[Category.get("Category one").id] = ''
  end

  def make_category_sale
    Sale.new_from_params categories: @categories_hash, discount: 50
  end

  it{ make_category_sale.categories.should include(Category.get("Category one"))}

  it{
    expect{ make_category_sale}
    .to change{ products.first.on_discount?}
    .from(false).to(true)  
  }
  it{
    expect{ make_category_sale}
    .to_not change{ Product.all.all?(&:on_discount?) }.from(false)
  }
end
end