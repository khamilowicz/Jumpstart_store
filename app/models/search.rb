class Search

  SearchQuery = Struct.new(:name, :params)

  include ActiveModel::Conversion
  include ActiveModel::Validations
  extend ActiveModel::Naming
  def persisted?; false; end

  attr_accessor :searched

  def initialize params={}
    @searched = []
    parse_searchable params
  end

  def parse_searchable params
    params.delete_if{|n, sp| skip? sp}.each do |name, search_params|
      searched << SearchQuery.new(name, search_params.values)
    end
  end

  def skip? params
    params.values.first.blank?
  end

  def find_order
    order = Order.scoped
    searched.each do |query|
      order = order.send "find_by_#{query.name}", *query.params
    end
    order.all
  end

  alias_method :find, :find_order
end