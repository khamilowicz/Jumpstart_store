 require "spec_helper"

 def create_new_product product
 	visit new_product_path
 	fill_in "Title", with: product.title
 	fill_in "Description", with: product.description
 	fill_in "Price", with: product.price
 	attach_file(product.photo)
 	click_button "Submit"
 end

 describe "Administrator" do
 	subject{page}
 	context "managing products" do
 		describe "creates products list" do 

 			before(:each) do
 				@new_product = FactoryGirl.build(:product)
 				create_new_product @new_product
 			end

 			it {should have_content("Successfully created product")}
 			it{ should have_selector('.product .title', text: @new_product.title)}
 			it{ should have_selector('.product .description', text: @new_product.description)}
 			it{ should have_selector('.product .price', text: @new_product.price.to_s)}
 			it{ find(".product .photo img").should have_link(@new_product.photo_url)}

 		end

 		it "Modify existing products title, description, price, and photo"
 		it "Create named categories for products"
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
 			it 'Order date and time'
 			it 'Purchaser full name and email address'
 			it 'For each product on the order'
 			it 'Name with link to product page'
 			it 'Quantity'
 			it 'Price'
 			it 'Line item subtotal'
 			it 'Total for the order'
 			it 'Status of the order'
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