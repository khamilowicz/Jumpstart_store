class Session
	extend ActiveModel::Naming
	include ActiveModel::Conversion

	attr_accessor :email, :password

  class << self
    def authenticate params
      user = User.where(email: params[:email]).first
      return user if user && user.authenticate(params[:password])
    end
  end

  def persisted?
    false
  end
end