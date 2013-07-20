require "spec_helper"

# def build_order products=nil
#   products = FactoryGirl.create_list(:product, 1) unless products
#   user = FactoryGirl.create(:user)
#   products.each do |product|
#     user.add product: product
#   end
#   order = user.orders.build
#   order.address = user.address
#   order.transfer_products
#   order
# end

def build_better_order products, user
  order = Order.new
  order.user = user
  order.address = user.address
  order.save
  products.each do |product|
    order.add product: product
  end
  order.save
  order
end

def build_order products=nil
 products = FactoryGirl.create_list(:product, 1) unless products
 order = Order.new
 order.stub(valid?: true, user: double('User'))
 order.save
 products.each do |product|
  order.add product: product
end 
order

end


def create_order products=nil
  order = build_order(products)
  order.save
  order
end

def add_products_to_cart products
  visit products_path
  products = [products] unless products.kind_of? Array
  products.each do |product|
    within(".product.#{product.title_param}") { click_link "Add to cart" }
  end
end

def login user 
  click_link 'Log in'
  fill_in 'Email', with: user.email
  fill_in 'Password', with: user.password
  click_button "Sign in"
end

def order_some_products_for_real products
  add_products_to_cart products
  visit cart_path
  click_link "Order"
  fill_in :'card-number', with: 4111111111111111
  fill_in :'card-cvc', with: 123
  fill_in :'card-expiry-month', with: 12
  fill_in :'card-year', with: 2020
  click_button "Buy"
end

def current_user
 user.kind_of?(UserPresenter) ? user.user : user
end

def order_some_products products
  add_products_to_cart products
  current_user.orders.create do |order| 
    order.address = FactoryGirl.create(:address)
    order.transfer_products
    order.pay
  end
end

def add_a_review review 
  within(".new_review"){
    fill_in 'review[title]', with: review.title
    fill_in 'review[body]', with: review.body
    fill_in( 'review_note', with: review.note.to_s)
  }
  click_button "Send review"
end


def some_photo
  "./spec/files/sean.jpeg"
end 

def create_new_product product
  fill_in "Title", with: product.title
  fill_in "Description", with: product.description
  fill_in "Base price", with: product.price
  attach_file("assets_photos", some_photo)

  find('form input[name="commit"]').click
  # click_button "Create Product"
end

def add_to_category product, category_name
  visit product_path(product)
  click_link "Add to category"
  fill_in "New category name", with: category_name
  click_button "Submit"
end

def put_on_sale stuff, name=nil
  visit new_sale_path
  fill_in 'name', with: (name || "Some kind of sale")
  fill_in "discount", with: '50'
  stuff.each do |name|
    check name 
  end
  click_button "Submit"
end

def fill_address street=nil
  select "United States", from: 'Country'
  fill_in 'City', with: "Washington"
  fill_in 'Zip code', with: "80130"
  fill_in 'Street', with: (street || "Pensylwania")
  fill_in 'House nr', with: 10
  fill_in 'Door nr', with: 15
end