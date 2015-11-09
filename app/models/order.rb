class Order < ActiveRecord::Base
  belongs_to :site
  belongs_to :program
  belongs_to :user

  def submit!
    user = site.find_user_by_email(email)
    if !user
      user = site.users.build
      user.name = first_name + " " + last_name
      user.email = email
      user.password = SecureRandom.base64
      return false unless user.save
      user.send_activation_email
    end

    self.user = user
    save
    
    AdminMailer.new_order(self).deliver
    return true
  end
end
