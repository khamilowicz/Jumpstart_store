 require "spec_helper"

 describe "guest" do
  it_behaves_like 'user'
  it_behaves_like "user who can't"
  it "logs in, which should not clear the cart " do

    user = FactoryGirl.create(:user)
    product = FactoryGirl.create(:product, :on_sale)
    
    add_products_to_cart product
    
    visit '/cart'

    page.should have_content("Guest")
    page.should have_link("Log in")
    page.should_not have_link("Log out")
    page.should have_short_product(product)

    login user

    page.should have_content( "Successfully logged in")
    page.should have_content(user.display_name)
    page.should_not have_link("Log in")
    page.should have_link("Log out")

    visit '/cart'
    page.should have_short_product(product)

  end
end
