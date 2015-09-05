class InvitesController < ApplicationController
  # GET /invites
  # GET /invites.json
  def index
    @invites = @current_site.invites
  end

  def show
    invite = @current_site.invites.find_by(invite_key: params[:id])

    if invite.present? && !invite.expired? && !invite.destroyed? && !invite.redeemed?
      render
      return
    end

    redirect_to root_url
  end

  def show_admin
    @base_url = request.base_url
    @invite = @current_site.invites.find(params[:id])
  end

  # GET /invites/new
  def new
    @invite = @current_site.invites.build
  end

  # GET /invites/1/edit
  def edit
  end

  # POST /invites
  def create
    @invite = Invite.invite_by_email @current_site, params[:invite][:email],
                                     current_user
    if @invite.id
      redirect_to action: 'show_admin', id: @invite.id
    else
      render :new
    end
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

  # DELETE /invites/1
  # DELETE /invites/1.json
  def destroy
    @invite = Invite.find(params[:id])
    @invite.destroy
    respond_to do |format|
      format.html { redirect_to invites_url, notice: 'Invite was successfully destroyed.' }
      format.json { head :no_content }
    end
  end

end
