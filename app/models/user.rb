require_dependency 'email'

class User < ActiveRecord::Base
  belongs_to :site

  before_validation :strip_downcase_email

  validates :email, presence: true, uniqueness: { scope: :site_id }
  validates :email, email: true, if: :email_changed?
  validate :password_validator
  validates :name, presence: true, if: :name_changed?

  has_secure_password

  def self.max_password_length
    200
  end

  def self.email_hash(email)
    Digest::MD5.hexdigest(email.strip.downcase)
  end

  def email_hash
    User.email_hash(email)
  end

  def password_validator
    #TODO: uncomment
    #PasswordValidator.new(attributes: :password).validate_each(self, :password, @raw_password)
  end

  # Returns the hash digest of the given string.
  def User.digest(string)
    cost = ActiveModel::SecurePassword.min_cost ? BCrypt::Engine::MIN_COST :
                                                  BCrypt::Engine.cost
    BCrypt::Password.create(string, cost: cost)
  end  

  def confirm_password?(password)
    return false unless password_hash && salt
    self.password_hash == hash_password(password, salt)
  end

  def update_ip_address!(new_ip_address)
    unless ip_address == new_ip_address || new_ip_address.blank?
      update_column(:ip_address, new_ip_address)
    end
  end

  protected

  def strip_downcase_email
    if self.email
      self.email = self.email.strip
      self.email = self.email.downcase
    end
  end

end

# == Schema Information
#
# Table name: users
#
#  id                            :integer          not null, primary key
#  created_at                    :datetime         not null
#  updated_at                    :datetime         not null
#  name                          :string(255)
#  email                         :string(256)      not null
#  password_digest               :string(64)       not null
#  auth_token                    :string(32)
#  ip_address                    :inet
#  registration_ip_address       :inet
#
# Indexes
#
#
