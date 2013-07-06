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
  describe "#title_param" do
    subject{ ProductPresenter.new FactoryGirl.build(:product, title: "this is product")}
    its(:title_param) {should eq('this-is-product') }

  describe "#quantity_for" do
    let(:product){  FactoryGirl.create(:product, quantity: 3) }
    let(:product_presenter){ ProductPresenter.new product }
    let(:user){ FactoryGirl.create(:user)}

    it{ expect{user.add product: product}.to change{product_presenter.quantity_for(user)}.from(0).to(1)}
  end
  end

    describe "price" do
      let(:product){ProductPresenter.new FactoryGirl.create(:product)}

      it{ (product.price + product.price).cents.should eq(200) }
      it{ (product.price + product.price).should eq(Money.new(200, "USD")) }
    end

       describe "discounts" do
      let(:product){ ProductPresenter.new FactoryGirl.build(:product)}
      
      it{ expect{product.on_discount 50}.to change{
        product.price
        }.from(product.base_price).to(product.base_price/2)
      }

      it{ expect{product.on_discount 50; product.off_discount}.to_not change{
        product.price
        }.from(product.base_price).to(product.base_price/2)
      }

    end
end