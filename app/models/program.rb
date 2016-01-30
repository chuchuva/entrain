class Program < ActiveRecord::Base
  belongs_to :site
  has_many :pages
  has_many :texts
  has_many :email_templates
  has_many :coupons
  has_many :invites
  has_many :orders
  has_many :program_participants, -> { where active: true }
  has_many :users, through: :program_participants

  def text(text_type)
    text = texts.find_by(text_type: text_type)
    text ? text.value : nil
  end

  def email_template(email_type)
    text = email_templates.find_by(email_type: email_type)
  end

  def apply_coupon(code)
    return price if code.blank?
    coupon = coupons.find_by(code: code)
    coupon ? coupon.price : price
  end

  def add_user(user)
    program_participants.create(site_id: site_id, user_id: user.id)
  end

  def remove_user(user)
    program_participants.find_by(user_id: user.id).update_attribute(
      :active, false)
  end
end
