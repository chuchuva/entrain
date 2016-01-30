require_dependency 'email'

class Invite < ActiveRecord::Base
  belongs_to :site
  belongs_to :program
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
    created_at < 30.days.ago
  end

  def redeem(password)
    InviteRedeemer.new(self, password).redeem unless expired? || destroyed? || redeemed?
  end

  def invite_by_email
    UserMailer.invite(self).deliver
  end

end
