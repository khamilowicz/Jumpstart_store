FactoryGirl.define do
	factory :order do
		user
		status 'pending'
		
		trait(:with_products) do
			after(:create) do |instance|
				create_list :product, 3, order: instance
			end
		end

		trait(:with_user) do
			after(:create) do |instance|
				 user = FactoryGirl.create(:user)
			end		 
		end
	end
end
