 require "spec_helper"


 describe "logged user" do

  it_behaves_like 'user'

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
      user = FactoryGirl.create(:user)
      products = FactoryGirl.create_list(:product, 2)
      @purchased_product = products.first
      @other_product = products.last
      visit '/'
      login user
      order_some_products @purchased_product

      visit '/products'
    end 
    context "he can" do

      before(:each) do
        click_link @purchased_product.title
        @review = FactoryGirl.build(:review)
        add_a_review @review 
      end

      context "Add a review including:" do

        it "Star rating 0-5, title, body " do
          within(".overall_note"){page.should have_note(@review.note) }
          page.should have_review(@review)
        end
        
      end
      it "Edit a review I’ve previously submitted until 15 minutes after I first submitted it" do
        review_2 = FactoryGirl.build(:review)
        review_2.note = 3
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