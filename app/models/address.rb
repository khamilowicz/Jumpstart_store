class Address < ActiveRecord::Base
  attr_accessible :country, :city, :zip_code, :street, :house_nr, :door_nr

  validates_numericality_of :zip_code, :house_nr, :door_nr, greater_than: 0

  belongs_to :user

  def to_s
    "#{self.country} #{self.zip_code} #{self.city} #{self.street} #{self.house_nr}/#{self.door_nr}"
  end

  def zip_code
    "" + super.to_s.first(2) + "-" + super.to_s.last(3)
  end
end