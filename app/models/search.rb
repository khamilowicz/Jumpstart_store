class Search
  include ActiveModel::Conversion
  include ActiveModel::Validations
  extend ActiveModel::Naming

  attr_accessor :status, :value, :total_value, :date, :date_value, :email, :searched

  def self.find params
    find_order params
  end

  def initialize params=nil
    super()
    if params
      @searched = []
      params.each do |name, par|
        @searched << {name: name, params: par.values } unless par.values.first.blank?
      end
    end
  end

  def self.find_order search
    order = Order.scoped
    search.searched.each do |query|
      order = order.send "find_by_#{query[:name]}", *query[:params]
    end
    order.all
  end

  def persisted?
    false
  end
end