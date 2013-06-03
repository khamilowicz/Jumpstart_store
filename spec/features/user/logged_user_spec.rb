 require "spec_helper"


 describe "logged user" do

  subject{page}

  before(:each) do
    @user = FactoryGirl.create(:user)
    visit '/'
    login @user
  end

  it_behaves_like 'user'
  it_behaves_like "user who can't"


  context "is allowed to" do

    it "log out" do 
      click_link "Log out"
      should_not have_content(@user.display_name)
      should_not have_content("Log out")
      should have_content("Guest")
      should have_link("Log in")
    end

    context "concerning orders" do
      before(:each) do
          @products = FactoryGirl.create_list(:product, 3, quantity: 3)
      end

      context "on new order page" do
        before(:each) do
          add_products_to_cart @products
          click_link "My cart"
          click_link 'Order'
        end

        it{should have_short_product(@products.first) }
        it{ should have_selector('.total', text: "Total for order: $3.0")}
      end

      context "after placing it", js: true do

        before(:each) do
          order_some_products @products
          visit orders_path
          @quantity_of_products_in_order = 1
          @order = @user.orders.first
        end

        it "cart is empty" do
          @order.products.should_not be_empty
          visit '/cart'
          @user.products.should be_empty
          @user.orders.first.products.should include_products(@products.first, @products.last)
          @products.each do |product|
            should_not have_short_product(product)

          end
        end

        it "view their past orders with links to display each order" do
          visit orders_path
          should have_content("Previous orders")
          should have_short_order(@order)
        end

        context "on that order display page there are" do

          before(:each) do
            visit order_path(@order)
          end

          it "products with quantity ordered and line-item subtotals" do
            @order.products.each do |product|
              within('.products'){
                should have_selector('.product', text: product.title)
                should have_selector(".product .quantity", text: @quantity_of_products_in_order.to_s)
              }
            end
          end

          it "links to each product page" do 
            @order.products.each do |product|
              within('.products'){
                should have_link(product.title)
              }
            end
          end

          it "the current status" do
            should have_selector(".status", content: @order.status)
          end

          it "order total price" do 
            should have_selector(".total_price", content: @order.total_price)
          end

          it "date/time order was submitted" do
            should have_selector(".submit_date", content: @order.date_of_purchase)
          end

          it "if shipped or cancelled, display a timestamp when that action took place" do
            should have_selector(".status", content: @order.status_change_date)
          end


          context "if any product is retired:" do
            before(:each) do
              @product = @order.products.first
              @product.retire 
              @product.product.save
              click_link @product.title
            end

            it "they can still access the product page" do
              should have_content(@product.title)
              should have_content(@product.description)
            end

            it "they cannot add it to a new cart" do 
              should_not have_link "Add to cart"
            end
          end
        end
      end

      it "Place a 'Two-Click' order from any active product page."
      it "The first click asks 'Place an order for ‘X’? and if you then click 'OK', the order is completed."
      it "Handle this in JavaScript or plain HTML at your discretion."
    end
  end

  context "on products he has purchased", js: true do

    before(:each) do
      products = FactoryGirl.create_list(:product, 2)
      @purchased_product = products.first
      @other_product = products.last
      order_some_products @purchased_product
      @review = FactoryGirl.build(:review)
      visit '/products'
    end 
    context "he can" do
      context "add a review" do

        before(:each) do
          click_link @purchased_product.title
          add_a_review @review 
          visit product_path(@purchased_product)
        end


        it "with star rating 0-5, title, body " do
          page.should have_review(@review)
          within(".overall_note"){page.should have_note(@review.note) }
        end
        
        it "and edit it if submitted until 15 minutes later" do
          review_2 = FactoryGirl.build(:review)
          review_2.note = 3
          visit product_path(@purchased_product)
          click_link "Edit review"
          add_a_review review_2
          page.should have_content("Successfully updated")
          page.should have_review(review_2)
          page.should_not have_review(@review)

          Delorean.jump(16*60) do
            visit product_path(@purchased_product)
            page.should_not have_link "Edit review"
            page.should have_review(review_2)
          end
        end
      end
    end
  end  
end