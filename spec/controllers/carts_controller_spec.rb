require "spec_helper"

describe CartsController do

  context ".show" do

    it "returns current_users' cart" do
      get :show
      assigns(:cart).class.should be(Cart)
    end

    it "returns cart if current_user is guest" do
      current_user = double(:guest? => true)
      get :show
      assigns(:cart).class.should be(Cart)
      current_user.guest?.should be_true
    end

    it "returns cart and creates current_user when none" do
      @current_user = nil
      session[:current_user_id] = nil
      get :show
      assigns(:cart).should_not be_nil
      expect(response).to render_template(:show)
    end
  end
end