class Order < ActiveRecord::Base
  belongs_to :site
  belongs_to :program
  belongs_to :user
  validates :email, presence: true, uniqueness: { scope: :program_id, message:
    'taken. Oops, it looks like you have purchased this program already. ' + 
    'Please contact us for assistance with getting access to the program.'}
  validates_presence_of :pay_method

  def submit!
    return false if invalid?
    user = site.find_user_by_email(email)
    if !user && pay_method.to_sym != :bank_transfer
      user = site.users.build
      user.name = first_name + " " + last_name
      user.email = email
      user.password = SecureRandom.base64
      return false unless user.save
      user.send_activation_email(program)
    end
    if pay_method.to_sym == :bank_transfer
      UserMailer.bank_transfer_instructions(self).deliver
    end

    self.user = user
    save
    
    AdminMailer.new_order(self).deliver
    return true
  end
end
