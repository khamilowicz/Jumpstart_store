require "spec_helper"

describe "Administrator" do

  let(:user){ UserPresenter.new FactoryGirl.create(:user, :admin) }

  before do
    visit '/'
    login user
  end

  subject {page}
  context "managing products" do
    describe "creates product" do

      let(:product){ ProductPresenter.new FactoryGirl.build(:product)}

      before do
        visit new_product_path
        create_new_product product
      end

      it{
       product.should_not be_nil
       should have_content("Successfully created product")
       should have_short_product(product)
       click_link product.title; should have_link("Edit product")}

       describe "and modifies them" do 
         let(:product_2){ ProductPresenter.new FactoryGirl.build(:product)}
         before do
           visit edit_product_path(1)
           create_new_product product_2
         end

         it {    
          should have_content("Successfully updated product")
          should_not have_short_product(product)
          should have_short_product(product_2)}
        end
      end

      describe "creates categories" do 
       before(:each) do
        @category_name = "Category_1"
        @product = ProductPresenter.new FactoryGirl.create(:product)
        add_to_category @product.product, @category_name
        visit '/categories'
        click_link @category_name
      end

      it{ 
        should have_content(@category_name)
        should have_short_product(@product)
      }
    end


    describe "assigns products to catgories" do
      before(:each) do
        categories = FactoryGirl.create_list(:category, 3)
        @add_to_product = categories[0,2]
        @not_added = categories[2]
        @products = ProductPresenter.new_from_array FactoryGirl.create_list(:product, 4)

        @product = @products.first
        visit product_add_to_category_path(@product)
      end

      it "assign to more than one category" do
        @add_to_product.each do |category|
          check category.name 
        end
        click_button 'Submit'
        visit product_path(@product)
        @add_to_product.each do |category|
          should have_content(category.name)
        end
        within('.categories'){should_not have_content(@not_added.name)}
      end

      describe "assigns many products to many categories" do
        before do
          visit manage_categories_path

          @products[0,2].each do |product|
            check product.title
          end
          @add_to_product.each do |category|
            check category.name
          end
          find('form input[name="commit"]').click
        end

        it 'should join products and categories' do
         @products[0,2].each do |product|
          product.categories.should eq(@add_to_product)
        end
      end
    end
  end

  it "retire a product from being sold, which hides it from browsing by any non-administrator" do
    @product = FactoryGirl.create(:product)
    visit edit_product_path(@product)
    uncheck :on_sale
    find("form input[name='commit']").click
    Product.find(@product.id).should_not be_on_sale
  end

  context "sees a listing of all orders" do
    before(:each) do
      @user = UserPresenter.new FactoryGirl.create(:user)
      visit '/'
      click_link 'Log out'
      login @user

      Order::STATUSES.each do |method, status|
        FactoryGirl.create_list(:product, 2).each do |product|
          @user.add product: product
        end
        order = @user.orders.create
        order.transfer_products
        order.address = FactoryGirl.create(:address)
        order.save
        Order.all.last.send method
      end

      click_link "Log out"
      login user
      visit orders_path

    end

    it "checks lots of things" do 

      %w{cancelled paid shipped returned}.each do |status|
        within(".orders .stats .#{status}"){ should have_content(Order.count_by_status(status))}
      end
      should have_link("Show")
      Order::STATUSES.each do |key, status| 
        other = Order::STATUSES
        other.delete status
        click_link status.capitalize
        other.each do |other_status|
          within(".order"){ should_not have_content(other_status) }
        end
        within(".order") do 
          should have_content(status) 
        end

        case status
        when 'pending'
          should have_link('Cancel')
          click_link  'Cancel'
          should have_content("Successfully updated order status to 'cancelled'")
        when 'shipped'
          should have_link('Mark as returned')
          click_link 'Mark as returned'
          should have_content("Successfully updated order status to 'returned'")
        when 'paid'
          should have_link('Mark as shipped')
          click_link 'Mark as shipped'
          should have_content("Successfully updated order status to 'shipped'")
        end
      end

      @order = Order.first
      @product = ProductPresenter.new @order.products.first
      @user = UserPresenter.new @user
      visit order_path(@order)
      should have_content("Order page")

      should have_content(@order.date_of_purchase.strftime("%d %b %Y")), "#{page.find("body").native}"
      should have_selector(".order .purchaser", text: @user.full_name)
      should have_selector(".order .purchaser", text: @user.email)
      should have_link(@product.title)
      should have_selector( ".products .product .quantity", text: @product.quantity.to_s)
      should have_selector( ".products .product .price", text: @product.price.to_s)
      should have_selector('.order .total_price', text: @order.total_price.to_s )
      should have_selector('.order .status', text: @order.status )
    end

    context "On the order 'dashboard' they can:" do
      before(:each) do
        @order ||= Order.last
      end
      context "View details of an individual order, including:" do
        before(:each) do
          visit "orders/#{@order.id}"
        end

        it "If purchased on sale, original price, sale percentage and adjusted price" do
          should have_content("Purchased on sale? No")
        # it "Subtotal for the order" do
        should have_content("Total price: $#{@order.total_price}")
        # it "Discount for the order" do
        should have_content("Total discount: #{@order.total_discount}")
      end
    end 
  end
  it 'View and edit orders; may change quantity or remove products from orders with the status of pending or paid' 
  it 'Change the status of an order according to the rules as outlined above' do
    Order.all.each do |order|
      page.should have_inline_order(order)
    end
    should have_link("Mark as shipped")
    should have_link("Mark as returned")
    should have_link("Cancel")
  end
end
end

context "not allowed to" do
  it 'modify any personal data aside from their own' do
    @user2 = FactoryGirl.create(:user, first_name: "Neil")
    visit edit_user_path(@user2)
    page.should have_no_content(@user2.first_name)
    page.should have_content("not allowed")
  end
end

context "he may" do

  before(:each) do
    @price ||= 1000
    @money_price ||= Money.new(@price, 'USD')
    @products ||= ProductPresenter.new_from_array FactoryGirl.create_list(:product, 3, base_price: @price)
    @category ||= ['Category_1']
    @products_in_category ||= @products[0,2]
    @products_in_category.each {|p| p.add category: @category.first}
    @product = @products.last
  end

  it{ @products_in_category.first.categories.should_not be_empty}

  it "View a list of all active sales" do 
    put_on_sale @products_in_category.map(&:title)
    visit sales_path

    should_not have_content(@product.title) 
    should have_content(@products_in_category.first.title), "#{page.find("body").native}"
  end

  describe "create a sale" do

    describe "for products" do
      before(:each) do
        put_on_sale @products_in_category.map(&:title), "Sale for products"
        visit sales_path
      end
      it{
        page.should have_short_product(@products_in_category.first)
        visit product_path(@products_in_category.first) 
        page.should have_content(@money_price*0.5)
      }

      describe "End a sale" do
        before(:each) do
          # put_on_sale [@product].map(&:title)
          visit sales_path
          within('.sale'){ click_link 'X'}
          visit sales_path
        end

        it { should_not have_short_product(@product) }
      end
    end

    it "for categories" do
      put_on_sale @category
      @products_in_category.each do |product| 
       visit product_path(product)
       product.sales.should_not be_empty
       should have_selector(".price", text: ((@money_price*0.5).to_s)), "#{page.find('body').native}"
     end
   end
 end

 context "search order using a builder-style interface (like Google’s 'Advanced Search;) allowing them to specify any of these:" do
  before(:each) do

    product_11 ||= ProductPresenter.new FactoryGirl.create(:product, base_price: 1100)
    product_9 ||= ProductPresenter.new  FactoryGirl.create(:product, base_price: 900)
    unless @pending_order
      @pending_order = create_order [product_11.product]
      @pending_order.created_at = Date.new(2011, 10,10)
      @pending_order.save
    end
    
    unless @cancelled_order
      @cancelled_order = create_order [product_9.product]
      @cancelled_order.created_at = Date.new(2008, 10,10)
      @cancelled_order.cancel
      @cancelled_order.save
    end

    click_link 'Search'
  end

  it 'Status (drop-down)' do
    select('pending', from: 'search[status][status]')
    click_button "Search"
    page.should have_short_order(@pending_order), "#{page.find('body').native}"
  end

  it 'Order total (drop-down for >, <, = and a text field for dollar-with-cents)' do
    fill_in('search[value][total_value]', with: '$10')
    select('more', :from => 'search[value][value]')
    click_button "Search"
    page.should_not have_short_order(@cancelled_order), "#{page.find('body').native}"
    page.should have_short_order(@pending_order), "#{page.find('body').native}"
  end

  it 'Order date (drop-down for >, <, = and a text field for a date)' do
    select("after", from: 'search[date][date]')
    select('2010', from: 'search[date][date_value(1i)]')
    select('October', from: 'search[date][date_value(2i)]')
    select('10', from: 'search[date][date_value(3i)]')
    click_button "Search"
    page.should have_short_order(@pending_order), "#{page.find('body').native}"
    page.should_not have_short_order(@cancelled_order), "#{page.find('body').native}"
  end
  it 'Email address of purchaser' do 
    fill_in(:email, with: @pending_order.user.email)
    click_button "Search"
    page.should have_short_order(@pending_order), "#{page.find('body').native}"
    page.should_not have_short_order(@cancelled_order), "#{page.find('body').native}"
  end
end
end
end
