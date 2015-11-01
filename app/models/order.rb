class Order < ActiveRecord::Base
  belongs_to :site
  belongs_to :program
  belongs_to :user

  def create!
    user = site.find_user_by_email(email)
    if !user
      user = site.users.build
      user.name = first_name + " " + last_name
      user.email = email
      user.password = SecureRandom.base64
      user.save
    end

    self.user = user
    save
    
    user.send_activation_email
    AdminMailer.new_order(self).deliver
  end
end
