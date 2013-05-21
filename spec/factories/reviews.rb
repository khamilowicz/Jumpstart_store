FactoryGirl.define do
	factory :review do
		sequence(:title){|n| "Review title #{n}"}
		sequence(:body){|n| "Review body #{n}"}
		note 1 

		after(:build) do |review|
			review.product = FactoryGirl.create(:product)
		end
	end
end