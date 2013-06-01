class Session
	extend ActiveModel::Naming
	include ActiveModel::Conversion

	attr_accessor :email, :password

  class << self
    def authenticate params
      iemail, ipassword = params[:email], params[:password]
      return User.where(email: iemail, password: ipassword).first
    end
  end

  def persisted?
    false
  end
end