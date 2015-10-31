require_dependency 'email'

class User < ActiveRecord::Base
  attr_accessor :reset_token
  belongs_to :site
  has_many :orders

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

  # Returns a random token.
  def User.new_token
    SecureRandom.urlsafe_base64
  end

  # Returns true if the given token matches the digest.
  def authenticated?(attribute, token)
    digest = send("#{attribute}_digest")
    return false if digest.nil?
    BCrypt::Password.new(digest).is_password?(token)
  end  

  # Sets the password reset attributes.
  def create_reset_digest
    self.reset_token = User.new_token
    update_attribute(:reset_digest,  User.digest(reset_token))
    update_attribute(:reset_sent_at, Time.zone.now)
  end

  # Sends password reset email.
  def send_password_reset_email
    UserMailer.password_reset(self).deliver
  end

  # Returns true if a password reset has expired.
  def password_reset_expired?
    reset_sent_at < 2.hours.ago
  end

  protected

    def strip_downcase_email
      if self.email
        self.email = self.email.strip
        self.email = self.email.downcase
      end
    end

end
