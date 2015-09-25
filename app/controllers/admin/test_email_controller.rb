class Admin::TestEmailController < ApplicationController
  before_action :logged_in_user

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
