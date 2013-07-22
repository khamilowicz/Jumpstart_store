class Review < ActiveRecord::Base

  attr_accessible :title, :body, :note
  validates_presence_of :body, :note, :product
  validates :note, numericality: {greater_than_or_equal_to: 1, less_than_or_equal_to: 5, only_integer: true}

  belongs_to :user
  belongs_to :product

  class << self
    def rating
      note = self.average :note
      note ? (note*2).round/2.0 : 0
       # calculation to make it only whole or 0.5
     end
   end

   def reviewer
    UserPresenter.new(user)
  end
end
