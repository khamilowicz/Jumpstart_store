require "spec_helper"
# require_relative './user_helper_spec'

describe "Administrator" do

  before(:each) do
    @admin = FactoryGirl.create(:user, :admin)
    visit '/'
    login @admin
  end

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
    it {click_link @product.title; should have_link("Edit product")}

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


describe "assigns products to catgories" do
  before(:each) do
    categories = FactoryGirl.create_list(:category, 3)
    @add_to_product = categories[0,2]
    @not_added = categories[2]

    @product = FactoryGirl.create(:product)
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
end

it "Retire a product from being sold, which hides it from browsing by any non-administrator"

context "sees a listing of all orders" do
  before(:each) do
    @user = FactoryGirl.create(:user)
    visit '/'
    click_link 'Log out'
    login @user

    Order.statuses.each do |method, status|
      products =  FactoryGirl.create_list(:product, 2)
      order_some_products products
      order = Order.last
      order.send method
    end

    click_link "Log out"
    login @admin
    visit orders_path

  end

  it "checks lots of things" do 
      # it "the total number of orders by status" do

      %w{cancelled paid shipped returned}.each do |status|
        within(".orders .stats .#{status}"){ should have_content Order.count_by_status(status)}
      end
      # end
      # it {
      should have_link("Show order")
      # }
      # it 'filter orders to display by status type (for statuses "pending", "cancelled", "paid", "shipped", "returned")' do
      Order.statuses.each do |key, status| 
        other = Order.statuses.delete_if{|x| x == status}
        click_link status.capitalize
        other.each do |other_status|
          within(".order"){ should_not have_content(other_status) }
        end
        within(".order") do 
          should have_content(status) 
        end
        case status
        when 'pending'
        # it 'link to "cancel" individual orders which are currently "pending"'
        should have_link('Cancel')
        click_link  'Cancel'
        should have_content("Successfully updated order status to 'cancelled'")
      when 'shipped'
        # it 'link to "mark as returned" individual orders which are currently "shipped"'
        should have_link('Mark as returned')
        click_link 'Mark as returned'
        should have_content("Successfully updated order status to 'returned'")
      when 'paid'
        # it 'link to "mark as shipped" individual orders which are currently "paid"'
        should have_link('Mark as shipped')
        click_link 'Mark as shipped'
        should have_content("Successfully updated order status to 'shipped'")
      end
    end

      # end
      # context "and can access details of an individual order, including:" do
        # before(:each) do

        @order = Order.first
        @product = @order.products.first
        visit order_path(@order)
        # end
        should have_content("Order page")

        # it {
        should have_selector(".order .submit_date", text: @order.date_of_purchase.to_s), "#{page.find("body").native}"
       # }
        # it {
        should have_selector(".order .purchaser", text: @user.full_name)
       # }
        # it {
        should have_selector(".order .purchaser", text: @user.email)
       # }
        # it {
        within(".products .product .title"){ should have_link(@product.title)}
       # }
        # it {
        should have_selector( ".products .product .quantity", text: @product.quantity.to_s)
       # }
        # it {
        should have_selector( ".products .product .price", text: @product.price.to_s)
       # }
        # it {
        should have_selector( ".products .product .subtotal", text: @product.subtotal.to_s)
       # }
       # should have_selector(".products .product .discount", text: @product.discount)
        # it {
        should have_selector('.order .total_price', text: @order.total_price.to_s )
       # }
        # it {
        should have_selector('.order .status', text: @order.status )
       # }

        # it 'Update an individual order'

      end
      context "On the order 'dashboard' they can:" do
        context "View details of an individual order, including:" do

         it "If purchased on sale, original price, sale percentage and adjusted price"
         it "Subtotal for the order"
         it "Discount for the order"
         it "Total for the order reflecting any discounts from applicable sales"
       end 
     end
     it 'View and edit orders; may change quantity or remove products from orders with the status of pending or paid'
     it 'Change the status of an order according to the rules as outlined above'
   end
 end

 context "not allowed to" do
  it 'modify any personal data aside from their own'
end

context "he may" do

  before(:each) do
    @products = FactoryGirl.create_list(:product, 3)
    @category = ['Category_1']
    @products_in_category = @products[0,2]
    @products_in_category.each {|p| p.add_to_category @category.first}
    @product = @products.last
  end
  
  it "View a list of all active sales" do 
    put_on_sale @products_in_category
    visit sales_path
    should have_short_product(@products_in_category.first)
    should_not have_short_product(@product) 
  end

  describe "create a sale" do

    it "for products" do
      put_on_sale @products_in_category
      visit product_path(@products_in_category.last) 
      should have_selector(".price", text: (0.5*@products_in_category.last.price).to_s)
    end

    it "for categories" do
      put_on_sale @category
      @products_in_category.each do |product| 
       visit product_path(product) 
       should have_selector(".price", text: (0.5*product.price).to_s), "#{page.find('body').native}"
     end
   end


   describe "End a sale" do
    before(:each) do
      put_on_sale @product
      visit sales_path
      within('.sale'){ click_link 'End sale'}
      visit sales_path
    end

    it { should_not have_short_product(@product) }
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
