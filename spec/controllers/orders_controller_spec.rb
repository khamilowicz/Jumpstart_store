require "spec_helper"

def current_user_is_admin
 current_user = controller.send(:current_user=, FactoryGirl.create(:user, :admin))
end

def current_user_is_normal
 current_user = controller.send(:current_user=, FactoryGirl.create(:user))
end

describe OrdersController do


  describe ".new" do
    it "render form for purchasing a product with products from current user's cart" do
      current_user = current_user_is_normal
      current_user.add product: FactoryGirl.create(:product)
      get :new
      assigns(:products).should include(*current_user.products)
      assigns(:cart).should be_a(Cart)
    end

    it "redirects guests to login page" do
      get :new
      response.should redirect_to(new_session_path)
    end
  end

  describe ".change_status" do
    before(:each) do
      FactoryGirl.create(:order)
    end
    it "doesn't allow non-admin users" do
      current_user_is_normal
      get :change_status, order_id: 1
      response.should redirect_to(new_session_path)
    end

    it "doesn't allow guests" do
      get :change_status, order_id: 1
      response.should redirect_to(new_session_path)
    end

    context "allows admin" do
      before(:each) do
        current_user_is_admin
      end
      it "to change status"  do
        current_user_is_admin
        get :change_status, order_id: 1, status: 'cancel'
        response.should redirect_to(orders_path)
        Order.first.status.should match /cancelled/
      end

      it "to be redirected to order page if something goes wrong" do
        get :change_status, order_id: 1, status: 'somethingwrong'
        response.should redirect_to(order_path(1))
        Order.first.status.should match /pending/
      end
    end
  end

  describe ".filter" do
    before(:each) do
      FactoryGirl.create(:order)
    end

    it "allows only admin" do
      get :filter, status: 'pending'
      response.should redirect_to(new_session_path)
      current_user_is_normal
      get :filter, status: 'pending'
      response.should redirect_to(root_path)
      current_user_is_admin
      get :filter, status: 'pending'
      response.should render_template(:index)
    end

    it "returns only orders with given status" do
      order_pending = FactoryGirl.create(:order)
      current_user_is_admin
      order_cancelled = FactoryGirl.create(:order, status: 'cancelled')

      get :filter, status: 'cancelled'
      assigns(:orders).should include( order_cancelled)
      assigns(:orders).should_not include( order_pending)
    end
  end

  describe "create" do
    it "should description"
  end

  describe ".index" do
    it "should description"
  end

  describe ".show" do
    it "should description"
  end

  describe "filters" do
    it "should description"
  end
end