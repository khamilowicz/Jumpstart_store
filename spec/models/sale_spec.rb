require "spec_helper"

describe Sale do
  it{should respond_to(:discount)}
  it{ should validate_presence_of(:discount)}
  it{should respond_to(:name)}
  it{should have_and_belong_to_many(:products)}
  it{should validate_numericality_of(:discount)}
  it{ should_not allow_value(100).for(:discount)}
  it{ should_not allow_value(0).for(:discount)}

  let(:products){ FactoryGirl.create_list(:product, 2)}

  describe "creation" do
    before(:each) do
      @product = FactoryGirl.create(:product)
      @product.on_discount 10, 'sale'
    end

    subject{ @product.sales.first}

    it{ @product.sales.should have(1).item}
    its(:name){should eq('sale')}
    its(:discount){should eq(10)}

    describe "#get_discount" do
      it{ @product.sales.get_discount.should eq(10)}
      it{
        expect{@product.on_discount 13}
        .to change{@product.sales.get_discount}
        .from(10).to(13)
      }
      it{
        expect{@product.on_discount 9}
        .to_not change{@product.sales.get_discount}
      }

    end

    describe "and removement" do
      subject{ @product.sales.first}
      it{ expect{
       subject.remove product: @product}.
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

  describe "created from params" do

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
  end
end