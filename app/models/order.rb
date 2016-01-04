class Order < ActiveRecord::Base
  belongs_to :site
  belongs_to :program
  belongs_to :user
  validates :email, presence: true, uniqueness: { scope: :program_id, message:
    'taken. Oops, it looks like you have purchased this program already. ' + 
    'Please contact us for assistance with getting access to the program.'}

  def submit!
    return false if invalid?
    user = site.find_user_by_email(email)
    if !user && pay_method.to_sym != :bank_transfer
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
