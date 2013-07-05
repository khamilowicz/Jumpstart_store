require 'spec_helper'

describe OrderProduct do
  let(:product){ FactoryGirl.build(:product)}
  subject{ OrderProduct.convert(product)}

  it {should be_kind_of(OrderProduct)}
  its(:product){ should eq(product) }

  describe ".total_price" do
    
  end
end