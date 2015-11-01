require_dependency 'rate_limiter'

class SessionController < ApplicationController

  skip_before_filter :redirect_to_login_if_required
  skip_before_filter :preload_json, :check_xhr, only: ['become']

  def new
  end

  def csrf
    render json: {csrf: form_authenticity_token }
  end

  # For use in development mode only when login options could be limited or disabled.
  # NEVER allow this to work in production.
  def become
    raise Entrain::InvalidAccess.new unless Rails.env.development?
    user = @current_site.find_user_by_email(params[:session_id])
    raise "User #{params[:session_id]} not found" if user.blank?

    log_on_user(user)
    redirect_to path("/")
  end

  def create

    RateLimiter.new(nil, "login-hr-#{request.remote_ip}", 30, 1.hour).performed!
    RateLimiter.new(nil, "login-min-#{request.remote_ip}", 6, 1.minute).performed!

    return invalid_credentials if params[:password].length > User.max_password_length

    email = params[:email].strip

    user = @current_site.find_user_by_email(email)
    if user && user.password_set? && user.authenticate(params[:password]) 
      log_in user
      redirect_back_or root_url
    else
      invalid_credentials
    end
  end

  def forgot_password
    params.require(:email)

    unless allow_local_auth?
      render nothing: true, status: 500
      return
    end

    RateLimiter.new(nil, "forgot-password-hr-#{request.remote_ip}", 6, 1.hour).performed!
    RateLimiter.new(nil, "forgot-password-min-#{request.remote_ip}", 3, 1.minute).performed!

    user = @current_site.find_user_by_email(params[:email])
    user_presence = user.present?
    if user_presence
      email_token = user.email_tokens.create(email: user.email)
      Jobs.enqueue(:user_email, type: :forgot_password, user_id: user.id, email_token: email_token.token)
    end

    json = { result: "ok" }
    unless SiteSetting.forgot_password_strict
      json[:user_found] = user_presence
    end

    render json: json

  rescue RateLimiter::LimitExceeded
    render_json_error(I18n.t("rate_limiter.slow_down"))
  end

  def destroy
    reset_session
    log_out
    redirect_to root_url
  end

  private

  def invalid_credentials
    flash.now[:danger] = 'Incorrect email or password.'
    render 'new'
  end

end
