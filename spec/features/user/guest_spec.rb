require "spec_helper"

shared_examples_for "user" do

  subject{page}

  before(:each) do
    @products = FactoryGirl.create_list(:product, 2, :on_sale, quantity: 3)
    @product = @products.first
    visit '/products' 
  end

  context "while browsing products" do

    it {should have_short_product(@products.first)}
    it {should_not have_selector(".product .quantity")}

    context "adds product to his cart" do
      before(:each) do
        within('.product#0'){click_link 'Add to cart'}
      end

      it {should have_content("#{@products.first.title} added to cart")}
      it { should have_selector(".product .quantity", text: '1 in cart')}

      it "many times" do
        click_link "Add more"
        should have_selector(".product .quantity", text: '2 in cart')
      end 

      context "where" do

        before(:each) { visit '/cart' }

        it {should have_short_product(@products.first)}
        it {should_not have_short_product(@products.last)}
      end
    end

    context "sees sale prices" do
      before(:each) do
        @price = 150.60
        @discount = 50
        product = @products.first
        product.price = @price
        product.on_discount @discount
        product.save
        visit products_path
      end

      it {should have_selector('.product .price .base', text: "$#{@price}")}
      it {should have_selector('.product .price .current', text: "$#{@discount*@price.to_f/100}")}
      it {should have_selector('.product .price .discount', text: "You save #{@discount}%!")}
    end

    context "go to product page" do
      before(:each) do
        visit product_path(@product)
      end

      context "and sees reviews" do
        before(:each) do
          @reviews = FactoryGirl.create_list(:review, 2)
          @reviews.each.with_index do |review, index| 
            review.note = index+1
            @product.add_review review
          end
          visit product_path(@product)
        end

        it {should have_review(@reviews.first)}
        it {within(".overall_note"){should have_note(1.5)}}
        it {within(".overall_note"){should_not have_note(3.5)}}
      end
    end
  end


  context "while browsing categories" do
    before(:each) do
      @categories =['Category_1', 'Category_2'] 
      @products.first.add_to_category @categories.first
      @products.first.add_to_category @categories.last
      @products.last.add_to_category @categories.last
      visit '/categories'
    end

    it{ @categories.each {|category| page.should have_link(category) } }

    context "and looking at category page" do
      context "with one product" do
       before(:each) do
        click_link @categories.first
      end 
      it {should have_content(@categories.first)}
      it {should have_short_product(@products.first)}
      it {should_not have_content(@categories.last)}
      it {should_not have_short_product(@products.last)}
    end

    context "with two products" do
     before(:each) do
      click_link @categories.last 
    end 

    it {should have_content(@categories.last)}
    it {should_not have_content(@categories.first)}
    it {should have_short_product(@products.last)}
    it {should have_short_product(@products.first)}
  end
end

context "while viewing his cart" do

  before(:each) do
    add_products_to_cart [@product]
    visit '/cart'
  end

  it {should have_content("cart")}
  it {should have_short_product(@product)}

  context "removes a product from his cart" do 
    before(:each) do
      within(".product#0.#{@product.title_param}"){ click_link 'Remove from cart'}
    end
    it {should have_content("#{@product.title} removed from cart")}
    it {should_not have_short_product(@product)}
  end 
end

it 'search for products in the whole site'
it 'search through "My Orders" for matches in the item name or description'
end
end

shared_examples_for "user who can't" do

  describe "View another user’s"  do
    before(:each) do
      @user = FactoryGirl.create(:user)
      @product = FactoryGirl.create(:product, :on_sale)
      @user.add_product @product 
    end

    describe "profie" do
      before(:each) do
        visit user_path(@user)
      end

      it{ should have_content("You can't see other user's profile")}
      it{ should_not have_content(@user.full_name)}
    end

    describe 'cart' do
      before(:each) do
        visit cart_path(@user.cart)
      end

      it{ should have_content("You can't see other user's cart")}
      it{ should_not have_short_product(@product)}
    end

    describe 'order' do 
      before(:each) do
        @order = @user.orders.new
        @order.transfer_products
        @order.address = 'lala'
        @order.save
        visit order_path(@order)
      end

      it{ should have_content("You can't see other user's order"), "#{page.find("body").native}"}
      it{ should_not have_content(@user.display_name)}
    end
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

describe "guest" do
  it_behaves_like 'user'
  it_behaves_like "user who can't"

  subject {page}
  context "while not logged in" do
    before(:each) do
      visit '/cart'
    end

    it { should have_content("Guest")}
    it { should have_link("Log in")}
    it { should_not have_link("Log out")}
  end

  context "logs in" do

    before(:each) do
      @user = FactoryGirl.create(:user)
      @product = FactoryGirl.create(:product, :on_sale)
      add_products_to_cart @product
      login @user 
    end
    
    it { should have_content( "Successfully logged in")}
    it { should have_content(@user.display_name)}
    it { should_not have_link("Log in")}
    it { should have_link("Log out")}
    it "which doesn't clear the cart" do
      visit '/cart'
      should have_short_product(@product)
    end
  end

end
