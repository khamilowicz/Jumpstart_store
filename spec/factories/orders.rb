# Read about factories at https://github.com/thoughtbot/factory_girl

FactoryGirl.define do
  factory :order do

  	address "Some address"
    after(:build) do |order|
    	order.user = FactoryGirl.build(:user)
    	order.products << FactoryGirl.build(:product)
    end
  end
end
