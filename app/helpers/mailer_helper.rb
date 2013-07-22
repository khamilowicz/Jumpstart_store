module MailerHelper

 def generate_registration_link user
  email_hash = BCrypt::Password.create user.email
  params = {email: email_hash}.to_param
  return "#{params}"
end
end