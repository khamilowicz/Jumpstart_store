require "spec_helper"

def add_products_to_cart products
  visit '/products'
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
  visit '/cart'
  click_link "Order"
  click_link "Buy"
end

def add_a_review review 
  within(".new_review"){
    fill_in 'Title', with: review.title
    fill_in 'Body', with: review.body
    select(review.note.to_s, from: 'review_note')
  }
  click_button "Send review"
end