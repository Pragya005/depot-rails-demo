class PasswordsMailer < ApplicationMailer
  default from: "Pragya Varshney <pragyavarshney.web@gmail.com>"

  def reset(user)
    @user = user
    mail subject: "Reset your password", to: user.email_address
  end
end
