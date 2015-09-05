require_dependency 'email'

class Invite < ActiveRecord::Base
  belongs_to :site
  include Trashable

  belongs_to :user
  belongs_to :invited_by, class_name: 'User'

  validates_presence_of :invited_by_id
  validates :email, email: true

  before_create do
    self.invite_key ||= SecureRandom.hex
  end

  before_validation do
    self.email = Email.downcase(email) unless email.nil?
  end

  validate :user_doesnt_already_exist
  attr_accessor :email_already_exists

  def user_doesnt_already_exist
    @email_already_exists = false
    return if email.blank?
    u = site.find_user_by_email(email)
    if u && u.id != self.user_id
      @email_already_exists = true
      errors.add(:email, "already exists")
    end
  end

  def redeemed?
    redeemed_at.present?
  end

  def expired?
    created_at < SiteSetting.invite_expiry_days.days.ago
  end

  def redeem(password)
    InviteRedeemer.new(self, password).redeem unless expired? || destroyed? || redeemed?
  end

  # Create an invite for a user
  #
  # Return the previously existing invite if already exists. Returns nil if the invite can't be created.
  def self.invite_by_email(site, email, invited_by)
    lower_email = Email.downcase(email)

    invite = site.invites.with_deleted
                   .where(email: lower_email, invited_by_id: invited_by.id)
                   .order('created_at DESC')
                   .first

    if invite && (invite.expired? || invite.deleted_at)
      invite.destroy
      invite = nil
    end

    if !invite
      invite = site.invites.create(invited_by: invited_by, email: lower_email)
    end

    invite.reload unless invite.new_record?
    invite
  end

end
