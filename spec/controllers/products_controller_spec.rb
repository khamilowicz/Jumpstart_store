require "spec_helper"

describe ProductsController do
	describe "GET index" do
		it "should retrieve empty products array" do
			get :index
			assert_response :success
			assert_empty assigns(:products)
		end
		it "retrives not empty products array" do
			products = FactoryGirl.create_list(:product, 2, on_sale: true)
			get :index
			assert_response :success
			# assert_not_nil assigns(:products)
			assigns(:products).should == products 
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

	describe "GET show" do
		# it "should retrieve product with send id" do
		# 	product = FactoryGirl.create(:product)
		# 	get :show, id: product.id
		# 	assert_response :success
		# 	assigns(:product_presenter).should == ProductPresenter.new(product)
		# 	assert_template 'show'
		# end

	end
end