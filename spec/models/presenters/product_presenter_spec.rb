require "spec_helper"

describe ProductPresenter do

  # let(:product){ FactoryGirl.create(:product)}
  let(:product){ Product.new }
  let(:product_presenter){ ProductPresenter.new product}
  subject{ product_presenter }


  describe "#list_categories" do

    before(:each) do
      product.stub(:valid? => true)
      product.add category: 'C_1'
      product.add category: 'C_2'
    end
    its(:list_categories){ should eq('C_1, C_2') }
  end

  its(:title){ should eq(product.title)}
  describe "#title_param" do
    before :each do
      product.title = "this is product"
    end

    its(:title_param) {should eq('this-is-product') }
  end

  describe "#quantity_for_user" do
    let(:product){  FactoryGirl.build(:product, quantity: 3) }
    let(:user){ FactoryGirl.create(:user)}

    it{ expect{user.add product: product}.to change{ ProductPresenter.new(product, user).quantity_for_user}.from(0).to(1)}
  end

  describe "price" do
    let(:price){ Money.new(100, "USD")}

    before :each do
      product.base_price = price
    end

    it{ (product_presenter.price + product_presenter.price).cents.should eq(200) }
    it{ (product_presenter.price + product_presenter.price).should eq(Money.new(200, "USD")) }

    describe "discounts" do
    let(:product){ ProductPresenter.new FactoryGirl.create(:product)}

    it{ expect{product_presenter.set_discount 50}.to change{
      product_presenter.price
      }.from(product_presenter.base_price).to(product_presenter.base_price/2)
    }

    it{ 
      product_presenter.set_discount 50;
      expect{ product_presenter.off_discount}.to change{
      product_presenter.price
      }.from(product_presenter.base_price/2).to(product_presenter.base_price)
    }
  end
end
end