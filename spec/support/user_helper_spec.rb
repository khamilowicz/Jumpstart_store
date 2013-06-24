require "spec_helper"

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

def order_some_products products
  add_products_to_cart products
  visit cart_path
  click_link "Order"
  fill_in :'card-number', with: 4111111111111111
  fill_in :'card-cvc', with: 123
  fill_in :'card-expiry-month', with: 12
  fill_in :'card-year', with: 2020
  click_button "Buy"
end

def add_a_review review 
  within(".new_review"){
    fill_in 'Title', with: review.title
    fill_in 'Body', with: review.body
    select(review.note.to_s, from: 'review_note')
  }
  click_button "Send review"
end


def some_photo
  "./spec/files/sean.jpeg"
end 
def create_new_product product
  fill_in "Title", with: product.title
  fill_in "Description", with: product.description
  fill_in "Price", with: product.price
  attach_file("assets_photos", some_photo)
  click_button "Submit"
end

def add_to_category product, category_name
  visit product_path(product)
  click_link "Add to category"
  fill_in "New category name", with: category_name
  click_button "Submit"
end

def put_on_sale stuff
  stuff = [stuff] unless stuff.kind_of?(Array)
  names = stuff.first.kind_of?(Product) ? stuff.map(&:title) : stuff
  visit new_sale_path
  fill_in "discount", with: '50'
  names.each do |name|
    check name 
  end
  click_button "Submit"
end