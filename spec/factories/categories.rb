FactoryGirl.define do
  factory :category do
    sequence(:name){|n| "Category_name_#{n}"}
  end
end
