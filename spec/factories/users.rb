# Read about factories at https://github.com/thoughtbot/factory_girl

FactoryGirl.define do
  factory :user do
    realname "John Smith"
    
    sequence(:nick){|n| "Nick_#{n}"}
    sequence(:email){|n| "#{n}@gmail.com"}
    admin false
    guest false

    trait :guest do
      guest true 
    end
    
     

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
