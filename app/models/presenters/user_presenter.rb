class UserPresenter

  attr_accessor :user

  def initialize user 
    @user = user
  end

  def full_name
    "#{user.first_name} #{user.last_name}"
  end

  def display_name
    return 'Guest' if user.guest?
    user.nick || full_name
  end

  def method_missing name, *args, &block
    if @user.respond_to?(name.to_sym)
      @user.send name, *args, &block
    else
      super
    end
  end

  def respond_to? method_name, private_method = false
    if @user.respond_to?(method_name)
      true
    else
      super
    end
  end

  def to_param
    @user.to_param
  end

end