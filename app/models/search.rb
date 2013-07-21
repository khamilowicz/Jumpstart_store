
class Search

  SearchQuery = Struct.new(:name, :params)
  
  include ActiveModel::Conversion
  include ActiveModel::Validations
  extend ActiveModel::Naming

  attr_accessor :searched

  def initialize params=nil
    if params
      @searched = []
      params.each do |name, search_params|
        unless search_params.values.first.blank?
          @searched << SearchQuery.new(name, search_params.values) 
        end
      end
    end
  end

  def persisted?; false; end

  def find 
    Search.find self
  end

  class << self

    def find params
      find_order params
    end

    def find_order search
      order = Order.scoped
      search.searched.each do |query|
        order = order.send "find_by_#{query.name}", *query.params
      end
      order.all
    end
  end
end