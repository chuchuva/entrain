class AccountActivationsController < ApplicationController
  before_action :get_user,         only: [:edit, :update]
  before_action :valid_user,       only: [:edit, :update]

  def edit
  end

  def update
    if params[:user][:password].empty?
      @user.errors.add(:password, "can't be empty")
      render 'edit'
    elsif @user.update_attributes(user_params)
      @user.password_was_set!
      log_in @user
      flash[:success] = "Password has been set."
      redirect_to root_url
    else
      render 'edit'
    end
  end

  private
    def user_params
      params.require(:user).permit(:password, :password_confirmation)
    end
    
    # Before filters
    
    def get_user
      @user = @current_site.find_user_by_email(params[:email])
    end

    # Confirms a valid user.
    def valid_user
      unless (@user && @user.authenticated?(:activation, params[:id]))
        flash[:danger] = "Invalid activation link"
        redirect_to login_url
        return
      end
      if @user.password_set?
        flash[:danger] = "Password already set"
        redirect_to login_url
      end
    end
end
