class UserRegistration < ActionMailer::Base
  helper MailerHelper

  default from: "piotr.szeremeta@gmail.com"

  def registration_confirmation(user)
    @user = user

    mail(to: @user.email, subject: "Welcome" )
  end
end
