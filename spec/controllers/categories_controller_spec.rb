require "spec_helper"

describe CategoriesController do

  describe ".index" do
    it "returns all categories in the system and renders index" do
      get :index
      assigns(:categories).should be_an(Array)
      response.should render_template( :index)
    end
  end

  describe ".show" do
    it "returns category for given id, product" do
      product = FactoryGirl.create(:product)
      product.add category: "Some category"

      get :show, id: 1
      assigns(:category).should be_a(Category)
      assigns(:products).should include(product)
    end

    it "renders product index page" do
      FactoryGirl.create(:category)
      get :show, id: 1
      response.should render_template('products/index')
      
    end

    it "returns to category index page if there is no given category" do
      get :show, id: 1
      response.should redirect_to(categories_path)
    end
  end
end

