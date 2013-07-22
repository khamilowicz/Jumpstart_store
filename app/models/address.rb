class Address < ActiveRecord::Base
  attr_accessible :country, :city, :zip_code, :street, :house_nr, :door_nr

  validates_numericality_of :zip_code, :house_nr, :door_nr, greater_than: 0, only_integer: true, allow_nil: true

  belongs_to :user

  def to_s
    "#{self.country} #{self.zip_code_formed} #{self.city} #{self.street} #{self.house_nr}/#{self.door_nr}"
  end

  def zip_code_formed
    "" + self.zip_code.to_s.first(2) + "-" + self.zip_code.to_s.last(3)
  end
end