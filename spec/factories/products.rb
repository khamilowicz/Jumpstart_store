# Read about factories at https://github.com/thoughtbot/factory_girl

FactoryGirl.define do
  factory :product do
    sequence(:title){|x| "Product #{x}"}
    sequence(:description ){|x| "Description #{x}"}
    price '1.00'
    discount 100

    trait :with_photo do
     sequence(:photo){|x| "http://Photo.com/#{x}"} 
   end

   trait :on_sale do
    after(:build) do |product|
      product.start_selling
    end
  end

  trait :with_category do
    ignore do
      category_name "Category 1" 
    end
     
    after(:build) do |product, evaluator|
     product.add_to_category evaluator.category_name
   end
 end
end
end
