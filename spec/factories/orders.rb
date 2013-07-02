# Read about factories at https://github.com/thoughtbot/factory_girl

FactoryGirl.define do
  factory :order do

  	address "Some address"
    after(:build) do |order|
    	order.user = FactoryGirl.create(:user, :with_products)
      order.transfer_products
    end
  end
end
