# Read about factories at https://github.com/thoughtbot/factory_girl

FactoryGirl.define do
  factory :order do

    after(:build) do |order|
      user = FactoryGirl.create(:user, :with_products)
      order.user = user
      order.address = user.address
      order.transfer_products
    end
  end
end
