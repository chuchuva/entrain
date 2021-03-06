# Preview all emails at http://localhost:3000/rails/mailers/user_mailer
class UserMailerPreview < ActionMailer::Preview

  # Preview this email at http://playground.entrain.local:3000/rails/mailers/user_mailer/welcome
  def welcome
    user = User.first
    user.activation_token = User.new_token
    UserMailer.default_url_options[:host] = user.site.subdomain
    UserMailer.welcome(user, Program.first)
  end

  # Preview this email at http://playground.entrain.local:3000/rails/mailers/user_mailer/password_reset
  def password_reset
    user = User.first
    user.reset_token = User.new_token
    UserMailer.default_url_options[:host] = user.site.subdomain
    UserMailer.password_reset(user)
  end

  # Preview this email at http://playground.entrain.local:3000/rails/mailers/user_mailer/bank_transfer_instructions
  def bank_transfer_instructions
    UserMailer.bank_transfer_instructions(Order.first)
  end

  def invite
    UserMailer.invite(Invite.first, 'John')
  end

end
