require 'spec_helper'

describe OrderProduct do

  before(:each) do
     @product = FactoryGirl.build(:product)
      @op = OrderProduct.convert(@product)
    
  end
  describe 'self.convert' do
    it "converts product to OrderProduct" do
      @op.should be_kind_of(OrderProduct)
    end

    describe ".product" do
      it "has converted product" do
        @op.product.should == @product
      end
    end


  end
end
