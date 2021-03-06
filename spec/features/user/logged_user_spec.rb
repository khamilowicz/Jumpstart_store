 require "spec_helper"

 describe "logged user" do



  subject{page}
  let(:user){ @current_user}

  before do
   @current_user =  UserPresenter.new FactoryGirl.create(:user)
   

   fast_login user
   visit '/'
 end

 it_behaves_like 'user'
 it_behaves_like "user who can't"

 context "is allowed to" do

  it "log out" do 
    click_link "Log out"
    should have_no_content("#{user}")
    should have_no_content("Log out")
    should have_content("Guest")
    should have_link("Log in")
  end

  context "in profile" do

    it "change his profile data" do
      click_link user.to_s

      click_link "Edit profile"
      fill_address "Other address"
      find(".main_content form input[name='commit']").click
      page.should have_content("Update successfull")
      page.should have_content("Other address") 
    end

  end
  context "concerning orders" do
    let(:products){ ProductPresenter.new_from_array FactoryGirl.create_list(:product, 3, quantity: 3)}

    context "on new order page" do
      before(:each) do
        add_products_to_cart products
        click_link "My cart"
        click_link 'Order'
      end

      it{should have_short_product( products.first) }
      it{ should have_selector('.total', text: "Total for order: $3")}
    end
    
    it "order some products for real" do 
      response = double(response_code: 20000)
      Paymill::Transaction.stub(:create){response}
      expect{ order_some_products_for_real products }
      .to change{ current_user.orders.count}
      .by(1)
      page.should have_content("Order is processed")
    end

    context "after placing it" do

      let(:order){ user.orders.first}

      before do
        order_some_products products
        visit orders_path
        @quantity_of_products_in_order = 1
      end

      it "cart is empty" do
        order.products.should_not be_empty
        visit '/cart'
        user.products.should be_empty
        user.orders.first.products.should include_products(products.first, products.last)
        products.each do |product|
          should_not have_short_product(product)
        end
      end

      it "view their past orders with links to display each order" do
        visit orders_path
        should have_content("Previous orders")
        should have_short_order(order)
      end

      context "on that order display page there are" do

        before do
          visit order_path(order)
        end

        it "products with quantity ordered and line-item subtotals" do
          order.products.each do |product|
            within('.products'){
              should have_selector('.product', text: product.title)
              should have_selector(".product .quantity", text: @quantity_of_products_in_order.to_s), "#{page.find('.product').native}"
            }
          end
          # end

          # it "links to each product page" do 
          order.products.each do |product|
            within('.products'){
              should have_link(product.title)
            }
          end
          # end

          # it "the current status" do
          should have_selector(".status", content: order.status)
          # end

          # it "order total price" do 
          should have_selector(".total_price", content: order.total_price)
          # end

          # it "date/time order was submitted" do
          should have_selector(".submit_date", content: order.date_of_purchase)
          # end

          # it "if shipped or cancelled, display a timestamp when that action took place" do
          should have_selector(".status", content: order.status_change_date)
        end


        context "if any product is retired:" do
          let(:product){ order.products.first}
          before do
            product.retire 
            visit product_path(product)
          end

          it "they can still access the product page" do
            should have_content(product.title)
            should have_content(product.description)
          # end

          # it "they cannot add it to a new cart" do 
          should_not have_link "Add to cart"
        end
      end
    end
  end

  describe "Place a 'Two-Click' order from any active product page." do
    before(:each) do
      visit product_path(products.first)
    end
    it "The first click asks 'Place an order for ‘X’? and if you then click 'OK', the order is completed." do
      pending
      should have_button("Order")
      click_button("Order")
      user.orders.last.products.last.product.should eq(products.first)
    end
  end
end
end

context "on products he has purchased" do

  let(:purchased_product){ ProductPresenter.new FactoryGirl.create(:product)}
  let(:other_product){ProductPresenter.new FactoryGirl.create(:product)}
  let(:review){FactoryGirl.build(:review)}

  before do
    order_some_products purchased_product
    visit '/products'
  end 

  context "he can" do
    context "add a review" do

      let(:review_edited){ FactoryGirl.build(:review, note: 3)}

      before do
        visit product_path(purchased_product)
        add_a_review review 
        visit product_path(purchased_product)
      end

      it "with star rating 0-5, title, body " do
        page.should have_review(review)
        within(".overall_note"){page.should have_note(review.note) }
      end

      it "and edit it if submitted until 15 minutes later" do
        visit product_path(purchased_product)
        click_link "Edit review"
        add_a_review review_edited
        page.should have_content("Successfully updated")
        page.should have_review(review_edited)
        page.should_not have_review(review)

        Delorean.jump(16.minutes) do
          visit product_path(purchased_product)
          page.should_not have_link "Edit review"
          page.should have_review(review_edited)
        end
      end
    end
  end
end  
end