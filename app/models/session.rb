class Session
	extend ActiveModel::Naming
	include ActiveModel::Conversion

	attr_accessor :email, :password
	
	def persisted?
		false
	end
end