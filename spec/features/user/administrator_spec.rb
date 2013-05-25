 require "spec_helper"
 require_relative './user_helper_spec.rb'

 def some_photo
 	"./spec/files/sean.jpeg"
 end 
 def create_new_product product
 	fill_in "Title", with: product.title
 	fill_in "Description", with: product.description
 	fill_in "Price", with: product.price
 	attach_file("Photo", some_photo)
 	click_button "Submit"
 end

 def add_to_category product, category_name
 	visit product_path(product)
 	click_link "Add to category"
 	fill_in "New category", with: category_name
 	click_button "Submit"
 end

 describe "Administrator" do
 	subject {page}
 	context "managing products" do
 		describe "creates product" do
 			before(:each) do
 				@product = FactoryGirl.build(:product)
 				visit new_product_path
 				create_new_product @product
 			end

 			it { should have_content("Successfully created product")}
 			it { should have_short_product(@product)}
 			it {@product.photo.should_not be_nil}

 			describe "and modifies them" do 
 				before(:each) do
 					@product_2 = FactoryGirl.build(:product)
 					pro = Product.where(title: @product.title).first
 					visit edit_product_path(pro)
 					create_new_product @product_2
 				end

 				it { should have_content("Successfully updated product")}
 				it { should_not have_short_product(@product)}
 				it { should have_short_product(@product_2)}
 			end
 		end

 		describe "creates categories" do 
 			before(:each) do
 				@category_name = "Category_1"
 				@product = FactoryGirl.create(:product)
 				add_to_category @product, @category_name
 				visit '/categories'
 				click_link @category_name
 			end

 			it {should have_content(@category_name)}
 			it {should have_short_product(@product)}
 		end


 		it "Assign products to categories or remove them from categories. Products can belong to more than one category."
 		it "Retire a product from being sold, which hides it from browsing by any non-administrator"
 		it "As an Administrator, I can also view an order 'dashboard' where I can:"

 		context "See a listing of all orders with:" do
 			it "the total number of orders by status"
 			it "links for each individual order"
 			it 'filter orders to display by status type (for statuses "pending", "cancelled", "paid", "shipped", "returned")'
 			it 'link to transition to a different status:'
 			it 'link to "cancel" individual orders which are currently "pending"'
 			it 'link to "mark as returned" individual orders which are currently "shipped"'
 			it 'link to "mark as shipped" individual orders which are currently "paid"'

 		end
 		context "Access details of an individual order, including:" do
 			before(:each) do
 				@products =  FactoryGirl.create_list(:product, 2)
        @user = FactoryGirl.create(:user)
        visit '/'
        login @user
 				order_some_products @products
 				@order = Order.first
        visit order_path(@order)
        @product = @order.products.first
 			end

 			it { should have_selector(".order .submit_date", text: @order.date_of_purchase.to_s )}
 			it { should have_selector(".order .purchaser", text: @user.full_name)}
 			it { should have_selector(".order .purchaser", text: @user.email)}


 			it { within(".products .product .title"){ should have_link(@product.title)}}
 			it { should have_selector( ".products .product .quantity", text: @product.quantity.to_s)}
 			it { should have_selector( ".products .product .price", text: @product.price.to_s)}
 			it { should have_selector( ".products .product .subtotal", text: @product.subtotal.to_s)}
 			it { should have_selector('.order .total_price', text: @order.total_price.to_s )}
 			it { should have_selector('.order .status', text: @order.status )}

 			it 'Update an individual order'
 			it 'View and edit orders; may change quantity or remove products from orders with the status of pending or paid'
 			it 'Change the status of an order according to the rules as outlined above'
 		end
 	end

 	context "not allowed to" do
 		it 'modify any personal data aside from their own'
 	end

 	context "he may" do
 		context "put products or entire categories of products on sale. They can:" do

 			it "Create a 'sale' and connect it with individual products or entire categories"
 			it "Sales are created as a percentage off the normal price"
 			it "View a list of all active sales"
 			it "End a sale"

 		end
 		context "On the order 'dashboard' they can:" do
 			context "View details of an individual order, including:" do

 				it "If purchased on sale, original price, sale percentage and adjusted price"
 				it "Subtotal for the order"
 				it "Discount for the order"
 				it "Total for the order reflecting any discounts from applicable sales"
 			end 
 		end

 		context "search orders using a builder-style interface (like Google’s 'Advanced Search;) allowing them to specify any of these:" do

 			it 'Status (drop-down)'
 			it 'Order total (drop-down for >, <, = and a text field for dollar-with-cents)'
 			it 'Order date (drop-down for >, <, = and a text field for a date)'
 			it 'Email address of purchaser'
 		end 

 	end 
 end