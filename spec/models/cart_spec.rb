require 'spec_helper'

describe Cart do
	describe ".remove_product" do
		subject{ FactoryGirl.create(:user)}
		let(:product){ FactoryGirl.create(:product, :on_sale)}

		before(:each) do
			subject.add product: product
			subject.remove product: product
		end

		its(:products){ should_not include(product)}
		it{ subject.cart.products.should_not include(product)}
	end
end
