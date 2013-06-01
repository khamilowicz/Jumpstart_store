require 'spec_helper'

describe Cart do
	describe ".remove_product" do
		it "removes product from cart" do
			user = FactoryGirl.create(:user)
			product = FactoryGirl.create(:product, :on_sale)
			user.add product: product
			
			user.products.should include(product)
			user.cart.products.should include(product)

			user.remove product: product
			user.products.should_not include(product)
			user.cart.products.should_not include(product)
		end
	end
end
