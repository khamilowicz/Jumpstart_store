# Read about factories at https://github.com/thoughtbot/factory_girl

FactoryGirl.define do
  factory :user do
    first_name "John"
    last_name "Smith"
    sequence(:email){|n| "#{n}@gmail.com"}

    trait :admin do
    	admin true 
    end
    
    trait :with_order do
    	 after(:build) do |instance|
    	 	instance.orders << FactoryGirl.build(:order, :with_products)
    	 end
    end

    trait :with_empty_order do
    	 after(:build) do |instance|
    	 	instance.orders << FactoryGirl.build(:order)
    	 end
    end
    
     
     
  end
end
