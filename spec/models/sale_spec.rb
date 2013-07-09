require "spec_helper"

describe Sale do
  let(:products){ FactoryGirl.create_list(:product, 2)}
  before(:each) do
    @products_hash = {}
    products.each do |prod|
      @products_hash[prod.id] = ''
    end
    @sale = Sale.new products: @products_hash, discount: 50
  end

  it{@sale.discount_all; @sale.products.should include(*products)}

  it{
    expect{ @sale.discount_all}
    .to change{ Product.all.all?(&:on_discount?)}
    .from(false).to(true)  
  }
end