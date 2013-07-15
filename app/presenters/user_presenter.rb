class UserPresenter

  attr_accessor :user

  def initialize user 
    @user = user
  end

  def self.new_from_array users
    users.map { |p| self.new p }
  end

  def full_name
    "#{user.first_name} #{user.last_name}"
  end

  def to_s
    return 'Guest' if user.guest?
    user.nick || full_name
  end

  def method_missing(name, *args, &block)
    return @product.send name, *args, &block if @product.respond_to?(name)
    super # otherwise
  end

  def respond_to?(method_id, include_private = false)
    return true if @product.respond_to?(method_id)
    super #otherwise
  end

  def to_param
    @user.to_param
  end
end