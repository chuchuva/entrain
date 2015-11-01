class UsersController < ApplicationController
  skip_before_filter :verify_authenticity_token, only: [:create_from_ontraport]

  def new
    @user = @current_site.users.build
  end

  def create
    @user = @current_site.users.build(user_params)
    @user.password = SecureRandom.base64
    if @user.save
      @user.send_activation_email
      flash[:info] = "Please check your email to activate your account."
      redirect_to login_url
    else
      render 'new'
    end
  end

  def create_from_ontraport
    user = @current_site.users.build
    user.name = params[:name]
    user.email = params[:email]
    user.password = SecureRandom.base64
    user.password_set = false
    if user.save
      render plain: 'ok'
    else
      render json: user.errors, :status => :unprocessable_entity
    end
  end

  def set_password
    email = params[:email].strip
    return redirect_to root_url if email.blank?

    user = @current_site.find_user_by_email(email)
    if !user
      render plain: "Something is wrong. User with email address #{email} not found."
      return
    end

    if user.password_set?
      redirect_to root_url
      return
    end

    if request.post?
      @invalid_password = params[:password].blank? || params[:password].length > User.max_password_length

      if @invalid_password
        @error = 'Password is invalid'
      else
        user.password = params[:password]
        user.password_set = true
        user.save
        log_in user
        redirect_to root_url
        return
      end
    end
  end

  private

    def user_params
      params.require(:user).permit(:name, :email)
    end
end
