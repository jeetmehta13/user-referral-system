class UserMailer < ApplicationMailer
  def invitation_email(email, signup_url)
    @email = email
    @signup_url = signup_url
    mail(to: email, subject: "Invitation to sign up for My App")
  end
end
