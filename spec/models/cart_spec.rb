require 'spec_helper'

describe Cart do
	describe ".remove_product" do
		let(:user){ FactoryGirl.create(:user)}
		let(:product){ Product.new}
		subject{ user.cart}

		before :each do 
			product.on_sale = true
			product.stub(valid?: true)
			user.add product: product
		end

		its(:products){should include(product)}

		describe "remove product" do
			before(:each) do
				user.remove product: product
			end

			its(:products){ should_not include(product)}
		end

		describe "ordering" do
			let(:order){ user.orders.new}

			before(:each) do
				order.transfer_products
				order.save
			end
			it{ order.products.should have(1).item}
			its(:products){ should_not include(product)}
		end
	end
end
