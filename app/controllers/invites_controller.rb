class InvitesController < ApplicationController
  # GET /invites
  # GET /invites.json
  def index
    @invites = Invite.all
  end

  def show
    invite = Invite.find_by(invite_key: params[:id])

    if invite.present? && !invite.expired? && !invite.destroyed? && !invite.redeemed?
      render
      return
    end

    redirect_to root_url
  end

  def show_admin
    @base_url = request.base_url
    @invite = Invite.find(params[:id])
  end

  # GET /invites/new
  def new
    @invite = Invite.new
  end

  # GET /invites/1/edit
  def edit
  end

  # POST /invites
  # POST /invites.json
  def create
    @invite = Invite.invite_by_email params[:invite][:email], current_user

    respond_to do |format|
      if @invite
        format.html { redirect_to action: 'show_admin', id: @invite.id,
          notice: 'Invite was successfully created.' }
        format.json { render :show_admin, status: :created, location: @invite }
      else
        format.html { render :new }
        format.json { render json: @invite.errors, status: :unprocessable_entity }
      end
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
