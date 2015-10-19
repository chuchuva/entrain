class Site < ActiveRecord::Base
  has_many :users
  has_many :programs
  has_many :pages
  has_many :invites
  has_many :orders
  has_many :site_settings

  def setting(name)
    setting = site_settings.find_by(name: name)
    setting.nil? ? nil : setting.value
  end

  def find_user_by_email(email)
    users.find_by(email: Email.downcase(email))
  end

  def admins
    users.where(admin: true)
  end

end
