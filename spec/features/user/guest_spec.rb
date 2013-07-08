require "spec_helper"

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
  
  it "can't checkout" do 
    product = ProductPresenter.new FactoryGirl.create(:product)

    add_products_to_cart product 

    visit '/cart'
    within(".order_menu"){
      page.should have_content("You need to log in")
      page.should_not have_link("Order")
    }
  end

  context "logs in" do

    before(:each) do
      @user = UserPresenter.new FactoryGirl.create(:user)
      @product = ProductPresenter.new FactoryGirl.create(:product, :on_sale)
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
