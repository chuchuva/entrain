module SessionHelper
  TOKEN_COOKIE ||= "_t".freeze

  def log_in(user)
    unless user.auth_token && user.auth_token.length == 32
      user.auth_token = SecureRandom.hex(16)
      user.save!
    end
    cookies.permanent[TOKEN_COOKIE] = { value: user.auth_token, httponly: true }
  end

  # Returns the user corresponding to the auth token cookie.
  def current_user
    return @current_user if @current_user
    
    auth_token = cookies[TOKEN_COOKIE]
    if auth_token && auth_token.length == 32
      @current_user = User.find_by(auth_token: auth_token)
    end

    @current_user
  end

  # Returns true if the user is logged in, false otherwise.
  def logged_in?
    !current_user.nil?
  end

  def has_auth_cookie?
    cookie = cookies[TOKEN_COOKIE]
    !cookie.nil? && cookie.length == 32
  end

  # Logs out the current user.
  def log_out
    if (user = current_user)
      user.update_attribute(:auth_token, nil)
    end
    cookies[TOKEN_COOKIE] = nil
  end

  # Redirects to stored location (or to the default).
  def redirect_back_or(default)
    redirect_to(session[:forwarding_url] || default)
    session.delete(:forwarding_url)
  end

  # Stores the URL trying to be accessed.
  def store_location
    session[:forwarding_url] = request.url if request.get?
  end
end
