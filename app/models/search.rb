class Search
  include ActiveModel::Conversion
  include ActiveModel::Validations
  extend ActiveModel::Naming

  attr_accessor :status, :value, :total_value, :date, :date_value, :email

  def self.find params
    find_order params
  end

  def self.find_order params
    binding.pry
    orders = Order.all
    orders &= Order.all_by_status params[:status] unless params[:status].blank?
    orders &= Order.all_by_value(params[:value], params[:total_value]) unless params[:value].blank?
    orders &= Order.all_by_date(params[:date], params[:'date_value(1i)'],params[:'date_value(2i)'],params[:'date_value(3i)']) unless params[:date].blank?
    orders &= Order.all_by_email(params[:email]) unless params[:email].blank?
    orders
  end

  def find_product

  end

  def persisted?
    false
  end
end