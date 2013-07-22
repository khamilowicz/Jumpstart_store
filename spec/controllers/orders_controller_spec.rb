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
    before(:each) do
      @current_user = current_user_is_normal
    end

    it "calls paymill manager to do transaction" do
      PaymillManager.any_instance.stub(:transaction){true}
      PaymillManager.any_instance.should_receive(:transaction)
      .with(@current_user, '123432', @current_user.cart.currency)

      post :create, paymillToken: '123432'
    end

    it "returns to order creation page if paying 
    goes wrong, giving message" do
    PaymillManager.any_instance.stub(:transaction){false}
    PaymillManager.any_instance.stub(:error_message){'custom message'}

    post :create, paymillToken: '123432'

    response.should render_template(:new)
    controller.flash[:errors].should match /custom message/
  end

  it "returns to order creation page if order saving goes wrong, giving message" do
    PaymillManager.any_instance.stub(:transaction){true} 
    Order.any_instance.stub(:save){false}
    post :create, paymillToken: '123432'
    response.should render_template(:new)
  end
end

describe ".index" do
  it "shows all orders for current user who is normal" do
    current_user = current_user_is_normal
    order_for_user, order_for_other = FactoryGirl.build_list(:order, 2)
    current_user.orders << order_for_user
    get :index
    assigns(:orders).should include(order_for_user)
    assigns(:orders).should_not include(order_for_other)
  end

  it "shows all orders in system for admin" do 
    current_user_is_admin
    FactoryGirl.create_list(:order,2)
    get :index
    assigns(:orders).should eq(Order.all)
  end
end

describe ".show" do
  it "should description"
end

describe "filters" do
  it "should description"
end
end