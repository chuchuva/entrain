require_dependency 'email_renderer'

class UserMailer < ActionMailer::Base
  default from: "noreply@entrainhq.com"

  def account_activation(user, program)
    template = program ? program.email_template(:account_activation) : nil
    if template
      body = EmailRenderer.render(template.body,
        'activation_url' => edit_account_activation_url(user.activation_token,
                                                        email: user.email))
      mail(to: user.email, subject: template.subject) do |format|
        format.html { render text: body[:html] }
        format.text { render text: body[:text] }
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

  def bank_transfer_instructions(order)
    template = order.program.email_template(:bank_transfer_instructions)
    if template
      body = EmailRenderer.render(template.body, 'first_name' => order.first_name)
      mail(to: order.email, subject: template.subject) do |format|
        format.html { render text: body[:html] }
        format.text { render text: body[:text] }
      end
    end
  end

  def invite(invite)
    template = invite.program.email_template(:invite)
    url = "https://#{invite.site.subdomain}.entrainhq.com/invites/#{invite.invite_key}"
    if template
      body = EmailRenderer.render(template.body, 'first_name' => invite.first_name,
        'url' => url)
      mail(to: invite.email, subject: template.subject) do |format|
        format.html { render text: body[:html] }
        format.text { render text: body[:text] }
      end
    else
      @first_name = invite.first_name
      @url = url
      mail to: invite.email, subject: "Account activation"
    end
  end
end
