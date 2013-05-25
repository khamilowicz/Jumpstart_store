# require "spec_helper"

shared_examples_for "user" do

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
          # page.should show_its_content
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

shared_examples_for "user who can't" do

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