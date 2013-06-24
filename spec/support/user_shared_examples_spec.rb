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
    it {pending; should have_selector(".product .quantity")}

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

      it {should have_content("$#{@price}")}
      it {should have_content("$#{@discount*@price.to_f/100}")}
      it {should have_content("You save #{@discount}%!")}
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
            @product.add review: review
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
      @products.first.add category: @categories.first
      @products.first.add category: @categories.last
      @products.last.add category: @categories.last
      visit '/categories'
    end

    it{ @categories.each {|category| page.should have_link(category) } }

    context "and looking at category page" do
      context "with one product" do
       before(:each) do
        click_link @categories.first
      end 
      it {should have_short_product(@products.first)}
      it {should_not have_short_product(@products.last)}
    end

    context "with two products" do
     before(:each) do
      click_link @categories.last 
    end 

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
      within(".product.#{@product.title_param}"){ click_link 'X'}
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

  describe "can't" do

  describe "view another user’s"  do
    before(:each) do
      @other_user = FactoryGirl.create(:user, first_name: "Abe", last_name: "Lincoln")
      @product = FactoryGirl.create(:product, :on_sale)
      @other_user.add product: @product 
    end

    describe "profile" do
      before(:each) do
        visit user_path(@other_user)
      end

      it{ pending; should have_content("You can't")}
      it{ should_not have_content(@other_user.full_name)}
    end

    describe 'cart' do
      before(:each) do
        visit cart_path(@other_user.cart)
      end

      # it{ should have_content("You can't")}
      it{ should_not have_content("#{@other_user.display_name} cart")}
    end

    describe 'order' do 
      before(:each) do
        @order = @other_user.orders.new
        @order.transfer_products
        @order.address = 'lala'
        @order.save
        visit order_path(@order)
      end

      it{ pending; should have_content("You can't")}
      it{ should_not have_content(@other_user.display_name)}
      it {should_not have_content("Order page")}
    end
  end

 
  it "view the administrator screens or use administrator functionality" do
    visit admin_dashboard_path
    should_not have_content("Administrator Dashboard")
  end

  it "make himself an administrator"

end

end