class Admin::SendInviteController < Admin::AdminController
  def new
    @invite = @current_site.invites.build
  end

  def sendit
    @invite = Invite.invite_by_email @current_site, params[:email],
                                     current_user
    if @invite.id
      UserMailer.invite(@invite, params[:first_name]).deliver
      render plain: "Invite sent!"
    else
      render :new
    end
  end
end
