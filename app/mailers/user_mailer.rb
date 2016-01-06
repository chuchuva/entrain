require 'liquid'
require 'redcarpet'

class UserMailer < ActionMailer::Base
  default from: "noreply@entrainhq.com"

  def account_activation(user, program)
    template = program ? program.email_template(:account_activation) : nil
    if template
      text = Liquid::Template.parse(template.body).render(
        'activation_url' => edit_account_activation_url(user.activation_token,
                                                        email: user.email))
      markdown = Redcarpet::Markdown.new(Redcarpet::Render::HTML)
      html = markdown.render(text)
      mail(to: user.email, subject: template.subject) do |format|
        format.html { render text: html }
        format.text { render text: text }
      end
    else
      @user = user
      mail to: user.email, subject: "Account activation"
    end
  end

  def password_reset(user)
    @user = user
    mail to: user.email, subject: "Password reset"
  end
end
