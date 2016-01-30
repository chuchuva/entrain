class Admin::InvitesController < Admin::AdminController
  before_action :set_program, only: [:index, :new, :create]
  before_action :set_invite, only: [:show, :edit, :update, :destroy]

  def index
    @invites = @program.invites
  end

  def show
    @base_url = request.base_url
  end

  # GET /admin/programs/1/invites/new
  def new
    @invite = @program.invites.build
  end

  # POST /admin/programs/1/invites
  def create
    @invite = @program.invites.build(invite_params)
    @invite.site_id = @program.site_id
    @invite.invited_by = current_user
    if @invite.save
      @invite.invite_by_email
      redirect_to admin_program_invites_url(@program),
        notice: 'Invite has been sent.'
    else
      render :new
    end
  end

  def destroy
    program = @invite.program
    @invite.destroy
    redirect_to admin_program_invites_url(program),
      notice: 'Invite was successfully destroyed.'
  end

  private
    def set_invite
      @invite = @current_site.invites.find(params[:id])
    end

    def invite_params
      params.require(:invite).permit(:email, :first_name)
    end

end
