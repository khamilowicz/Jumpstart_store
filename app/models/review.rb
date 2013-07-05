class Review < ActiveRecord::Base

  attr_accessible :title, :body, :note
	validates_presence_of :body, :note, :product
	validates :note, numericality: {greater_than_or_equal_to: 1, less_than_or_equal_to: 5, only_integer: true}
  
	belongs_to :user
	belongs_to :product

	def reviewer_name
		UserPresenter.new(user).display_name
	end
end
