class Site < ActiveRecord::Base
  has_many :users
  has_many :programs
  has_many :invites

  def find_user_by_email(email)
    users.find_by(email: Email.downcase(email))
  end

end
