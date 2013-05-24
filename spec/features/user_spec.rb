require "spec_helper"

RSpec::Matchers.define :have_short_product do |product|
	match do |page_content|
		selector = ".product.#{product.title_param}" 
		page_content.should have_selector(selector)
		within(selector){
			page_content.should have_content(product.title)
		}
	end
end

RSpec::Matchers.define :have_review do |review|
	match do |page_content|
		within('.review'){
			page_content.should have_selector('.reviewer', text: review.reviewer_name)
			page_content.should have_selector('.title', text: review.title)
			page_content.should have_selector('.body', text: review.body)
			page_content.should have_note(review.note)
		}
	end

	failure_message_for_should do |page_content|
		"Expected #{page_content.find('.review').native} to have #{review.reviewer_name}, #{review.title}, #{review.body} and #{review.note} stars"
	end
end

RSpec::Matchers.define :have_note do |note|
	match do |page_content|
		within(".note"){
			page_content.all(".star").size.should == 5
			page_content.all(".star.full").size.should == note.floor

			if note.round != note
				page_content.all(".star.half").size.should == 1 
			else
				page_content.all(".star.half").size.should == 0
			end
		}
	end
end

RSpec::Matchers.define :have_short_order do |order|
	match do |page_content|
		within('.order'){
			page_content.should have_content(order.date_of_purchase)
			page_content.should have_content(order.total_price)
			page_content.should have_link("Show order")
		}
	end

	failure_message_for_should do |page_content|
		
		"Expected #{page_content.find(".order").native} to have #{order.date_of_purchase}, #{order.total_price}, and link 'Show order'"
	end
end

RSpec::Matchers.define :include_products do |*products|
	match do |arr|
		titles = arr.collect(&:title)
		products.collect(&:title).each do |title|
			titles.include?(title).should be_true
		end
	end
	
end

def add_products_to_cart products
	visit '/products'
	products = [products] unless products.kind_of? Array
	products.each do |product|
		within(".product.#{product.title_param}") { click_link "Add to cart" }
	end
end

def login user 
	click_link 'Log in'
	fill_in 'session[email]', with: user.email
	fill_in 'session[password]', with: user.password
	click_button "Sign in"
end

def order_some_products products
	add_products_to_cart products
	visit '/cart'
	click_link "Order"
	click_link "Buy"
end

shared_examples_for "simple user" do

	context "can" do

		it "browse all products" do
			products = FactoryGirl.create_list(:product, 2, :on_sale)
			visit '/products'
			products.each {|product| page.should have_short_product(product)}
		end

		it "browse products by category" do
			categories =['Category_1', 'Category_2'] 
			products = FactoryGirl.create_list(:product, 2, :with_category, category_name: categories.first)
			products.last.add_to_category categories.last
			visit '/categories'

			categories.each {|category| page.should have_link(category) }
			click_link categories.first

			page.should have_content(categories.first)
			page.should have_short_product(products.first)

			page.should_not have_content(categories.last)
			page.should have_short_product(products.last)

			visit '/categories'
			click_link categories.last

			page.should have_content(categories.last)
			page.should_not have_content(categories.first)

			page.should have_short_product(products.last)
			page.should_not have_short_product(products.first)
		end

		it "view his cart" do 
			visit '/cart'

			page.should have_content("My cart")
		end

		it "add a product to his cart" do
			products = FactoryGirl.create_list(:product, 2, :on_sale)
			visit '/products'

			within('.product#0'){click_link 'Add to cart'}
			page.should have_content("#{products.first.title} added to cart")

			visit '/cart'

			page.should have_short_product(products.first)
			page.should_not have_short_product(products.last)

		end

		it "remove a product from his cart " do 
			product = FactoryGirl.create(:product, :on_sale)
			add_products_to_cart [product]
			visit '/cart'
			within(".product#0.#{product.title_param}"){ click_link 'Remove from cart'}
			page.should have_content("#{product.title} removed from cart")
			page.should_not have_short_product(product)
		end 

		it "increase the quantity of a product in my cart " do
			product = FactoryGirl.create(:product, :on_sale, quantity: 3)
			visit '/products'

			within(".product"){
				page.should_not have_selector(".quantity")
				click_link "Add to cart"
			}

			within(".product"){
				page.should have_selector(".quantity", text: '1 in cart')
				click_link "Add more"
			}

			within(".product"){
				page.should have_selector(".quantity", text: '2 in cart')
			}
		end

		it 'search for products in the whole site'
		it 'search through "My Orders" for matches in the item name or description'

		context "on every product " do

			context "see the posted reviews including:" do

				it "display name of reviewer, title, body, and a star rating 0-5" do 
					product = FactoryGirl.create(:product, :on_sale)
					review = FactoryGirl.create(:review)
					product.add_review review

					visit '/products'
					within('.product#0'){
						click_link "Show more"
					}
					page.should have_review(review)
				end
			end

			it "see an average of the ratings broken down to half-stars" do
				product = FactoryGirl.create(:product, :on_sale)
				review = FactoryGirl.create_list(:review, 4)
				review.each.with_index do |review, index| 
					review.note = index+1
					product.add_review review
				end

				visit '/products'

				within(".#{product.title_param}"){
					click_link "Show more"
				}
				within(".overall_note"){
					page.should have_note(2.5)
					page.should_not have_note(3.5)
				}
				
			end
		end
	end
	it "Sale prices are displayed in product listings alongside normal price and percentage savings" do
		price = 150.60
		discount = 50
		product = FactoryGirl.create(:product, price: price, on_sale: true)
		product.on_discount discount
		product.save

		visit '/products'
		within('.product .price'){ 
			page.should have_content("$#{price}")
			page.should have_content("$#{discount*price.to_f/100}")
			page.should have_content("You save #{discount}%!")
		}
	end

end

shared_examples_for "simple user who can't" do

	it "View another user’s private data (such as current shopping cart, etc.)" do
		pending
		user = FactoryGirl.create(:user)
		product = FactoryGirl.create(:product, :on_sale)
		user.add_product product

		visit user_path(user)
	end

	it "Checkout (until they log in)" do 
		user = FactoryGirl.create(:user)
		product = FactoryGirl.create(:product)

		add_products_to_cart product 

		visit '/cart'
		page.should_not have_link "Order"
		page.should have_content "You need to log in to purchase products"
	end

	it "View the administrator screens or use administrator functionality"
	it "Make themselves an administrator"

end


describe "User:" do

	describe "unauthenticated user" do
		it_behaves_like 'simple user'
		it_behaves_like "simple user who can't"
		it "logs in, which should not clear the cart " do

			user = FactoryGirl.create(:user)
			product = FactoryGirl.create(:product, :on_sale)
			
			add_products_to_cart product
			
			visit '/cart'

			page.should have_content("Guest")
			page.should have_link("Log in")
			page.should_not have_link("Log out")
			page.should have_short_product(product)

			login user

			page.should have_content( "Successfully logged in")
			page.should have_content(user.display_name)
			page.should_not have_link("Log in")
			page.should have_link("Log out")

			visit '/cart'
			page.should have_short_product(product)

		end
	end

	describe "Authenticated Non-Administrators" do

		it_behaves_like 'simple user'

		context "is allowed to:" do

			it "log out" do 
				user = FactoryGirl.create(:user)
				visit '/'
				login user
				click_link "Log out"
				page.should_not have_content(user.display_name)
				page.should_not have_content("Log out")
				page.should have_content("Guest")
				page.should have_link("Log in")
			end

			

			context "concerning orders" do
				before(:each) do
					@user = FactoryGirl.create(:user)
					@products = FactoryGirl.create_list(:product, 3, quantity: 3)
					visit '/'
					login @user
					order_some_products @products
					@quantity_of_products_in_order = 1
					@order = @user.orders.first
				end
				
				it "place an order" do
					visit '/cart'
					@user.products.should be_empty
					@user.orders.first.products.should include_products(@products.first, @products.last)
					@products.each do |product|
						page.should_not have_short_product(product)
					end
				end

				it "view their past orders with links to display each order" do
					visit '/orders'
					page.should have_content("Previous orders")
					page.should have_short_order(@order)
				end

				context "on that order display page there are:" do

					before(:each) do
						visit order_path(@order)
					end

					it "products with quantity ordered and line-item subtotals" do
						@order.products.each do |product|
							within('.products'){
								page.should have_selector('.product', text: product.title)
								page.should have_selector(".product .quantity", text: @quantity_of_products_in_order.to_s)
							}
						end
					end

					it "links to each product page" do 
						@order.products.each do |product|
							within('.products'){
								page.should have_link(product.title)
							}
						end
					end

					it "the current status" do
						page.should have_selector(".status", content: @order.status)
					end

					it "order total price" do 
						page.should have_selector(".total_price", content: @order.total_price)
					end

					it "date/time order was submitted" do
						page.should have_selector(".submit_date", content: @order.date_of_purchase)
					end

					it "if shipped or cancelled, display a timestamp when that action took place" do
						page.should have_selector(".status", content: @order.status_change_date)
					end


					context "if any product is retired:" do
						before(:each) do
							@product = @order.products.first
							@product.retire 
							@product.product.save
							click_link @product.title
						end

						it "they can still access the product page" do
							page.should have_content(@product.title)
							page.should have_content(@product.description)
						end

						it "they cannot add it to a new cart" do 
							page.should_not have_link "Add to cart"
						end
					end

				end

				it "Place a 'Two-Click' order from any active product page."
				it "The first click asks 'Place an order for ‘X’? and if you then click 'OK', the order is completed."
				it "Handle this in JavaScript or plain HTML at your discretion."
			end
		end

		context "is NOT allowed to:" do

			it "view another user’s private data (such as current shopping cart, etc.)"
			it "view the administrator screens or use administrator functionality"
			it "make themselves an administrator"

		end

		context " On products he has purchased" do
			before(:each) do
				products = FactoryGirl.create_list(:product, 2)
				@purchased_product = product.first
				@other_product = product.last
				order_some_products @purchased_product

				visit '/products'
			end	
			context "he can" do
				before(:each) do
					visit @purchased_product.title
				end

				context "Add a rating including:" do
					it "Star rating 0-5" do
						find(".new_review.note").select('2')
						click_link "Submit"
						@purchased_product.rating.should == 2
					end
					
					it "Title"
					it "Body text"
				end
				it "Edit a review I’ve previously submitted until 15 minutes after I first submitted it"
			end

		end

	end

	describe "As an authenticated Administrator" do
		context "he can" do

			it "Create product listings including a title, description, price, and a photo"
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
end
