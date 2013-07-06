# Read about factories at https://github.com/thoughtbot/factory_girl

FactoryGirl.define do
  factory :product do
    sequence(:title){|x| "Product #{x}"}
    sequence(:description ){|x| "Description #{x}"}
    
    discount 100
    quantity 1
    on_sale true

    ignore do
     base_price 100
   end

   after(:build) do |product, evaluator|
    product.base_price = Money.new(evaluator.base_price, "USD")
  end

  trait :with_photo do
   sequence(:photo){|x| "http://Photo.com/#{x}"} 
 end

 trait :not_on_sale do
  on_sale false
end

trait :on_sale do
  on_sale true
end

trait :with_category do
  ignore do
    category_name "Category 1" 
  end

  after(:build) do |product, evaluator|
   product.add category: evaluator.category_name
 end
end
end
end
