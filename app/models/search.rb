class Search
  include ActiveModel::Conversion
  include ActiveModel::Validations
  extend ActiveModel::Naming

  attr_accessor :status, :value, :total_value, :date, :date_value, :email

  def self.find params
    find_order params
 end

 def find_order params
  orders = Order.all
   orders &= Order.find_by_status params[:status] unless params[:status].blank?
   orders &= Order.find_by_value(params[:value], params[:total_value]) unless params[:value].blank?
   date = [params[:'date_value(1i)'],params[:'date_value(2i)'],params[:'date_value(3i)']].join(',')
   orders &= Order.find_by_date(params[:date], date) unless params[:date].blank?
   orders
 end

 def find_product
   
 end

 def persisted?
  false
end
end