require "spec_helper"

describe ProductsController do
	describe "GET index" do
		it "should retrieve empty products array" do
			get :index
			assert_response :success
			assert_empty assigns(:products)
		end
		it "retrives not empty products array" do
			products = FactoryGirl.create_list(:product, 2)
			get :index
			assert_response :success
			# assert_not_nil assigns(:products)
			assigns(:products).should include(products.first)
		end

		it "retrieves only products on sale" do
			products = FactoryGirl.create_list(:product, 2)
			products.first.start_selling
			products.last.retire
			products.each(&:save)

			get :index
			assert_response :success
			assigns(:products).should include(products.first)
			assigns(:products).should_not include(products.last)

		end

	end
end