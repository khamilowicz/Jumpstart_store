# Read about factories at https://github.com/thoughtbot/factory_girl

FactoryGirl.define do
  factory :order do

  	address "Some address"
    after(:build) do |order|
    	order.user = FactoryGirl.create(:user)
    	order.products = FactoryGirl.create_list(:product, 1)
    end
  end
end
