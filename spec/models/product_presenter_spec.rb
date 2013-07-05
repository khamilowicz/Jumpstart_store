require "spec_helper"

describe ProductPresenter do

  let(:product){ FactoryGirl.create(:product)}
  let(:product_presenter){ ProductPresenter.new product}
  subject{ product_presenter }


  describe "#list_categories" do

    before(:each) do
      product.add category: 'C_1'
      product.add category: 'C_2'
    end
    its(:list_categories){ should eq('C_1, C_2') }
  end

  its(:title){ should eq(product.title)}
  
end