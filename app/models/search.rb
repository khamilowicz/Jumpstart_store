class Search
  include ActiveModel::Conversion
  include ActiveModel::Validations
  extend ActiveModel::Naming

  attr_accessor :status, :value, :total_value, :date, :date_value

  def self.find params
 orders = Order.all
    orders &= Order.find_by_status params[:status] if params[:status] != ''
    orders &= Order.find_by_value(params[:value], params[:total_value]) if params[:value] != ''
    date = [params[:'date_value(1i)'],params[:'date_value(2i)'],params[:'date_value(3i)']].join(',')
    orders &= Order.find_by_date(params[:date], date) if params[:date] != ''
    orders
  end

  def persisted?
    false
  end
end