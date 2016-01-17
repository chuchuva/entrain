class Admin::TestEmailController < Admin::AdminController
  def new
  end

  def send_email
    ActionMailer::Base.mail(from: "noreply@entrainhq.com",
                            to: params[:email],
                            subject: params[:subject],
                            body: "test").deliver
    render plain: "Email sent"
  end
end
