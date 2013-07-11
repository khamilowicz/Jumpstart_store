class Session
	extend ActiveModel::Naming
	include ActiveModel::Conversion

	attr_accessor :email, :password

  class << self
    def authenticate params
      user = User.where(email: params[:email]).first
      if user && user.authenticate(params[:password])
        user
      else 
        nil
      end
    end
  end

  def persisted?
    false
  end
end