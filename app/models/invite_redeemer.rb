InviteRedeemer = Struct.new(:invite, :password) do

  def redeem
    Invite.transaction do
      if invite_was_redeemed?
        process_invitation
        return invited_user
      end
    end

    nil
  end

  def self.create_user_from_invite(invite, password)
    user_exists = User.find_by_email(invite.email)
    return user if user_exists

    user = User.new(email: invite.email, password: password)
    user.save!

    user
  end

  private

  def invited_user
    @invited_user ||= get_invited_user
  end

  def process_invitation
    delete_duplicate_invites
  end

  def invite_was_redeemed?
    # Return true if a row was updated
    mark_invite_redeemed == 1
  end

  def mark_invite_redeemed
    Invite.where(['id = ? AND redeemed_at IS NULL AND created_at >= ?',
      invite.id, SiteSetting.invite_expiry_days.days.ago]).update_all(
      'redeemed_at = CURRENT_TIMESTAMP')
  end

  def get_invited_user
    result = get_existing_user
    result ||= InviteRedeemer.create_user_from_invite(invite, password)
    result
  end

  def get_existing_user
    User.find_by(email: invite.email)
  end

  def delete_duplicate_invites
    Invite.where('invites.email = ? AND redeemed_at IS NULL AND invites.id != ?', invite.email, invite.id).delete_all
  end
end