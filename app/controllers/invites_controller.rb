class InvitesController < ApplicationController

  def show
    invite = @current_site.invites.find_by(invite_key: params[:id])

    if invite.present? && !invite.expired? && !invite.destroyed? && !invite.redeemed?
      render
      return
    end

    redirect_to root_url
  end

  def update
    @invalid_password = params[:password].blank? || params[:password].length > User.max_password_length

    if @invalid_password
      @error = 'Password is invalid'
      render action: 'show'
    else
      invite = Invite.find_by(invite_key: params[:id])

      @user = invite.redeem(params[:password])
      if @user
        #TODO: uncomment
        #@user.email_tokens.create(email: @user.email, confirmed: true)
        log_in @user
        redirect_to root_url
      else
        render action: 'show'
      end
    end
  end
end
