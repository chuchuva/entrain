class Program < ActiveRecord::Base
  belongs_to :site
  has_many :pages
  has_many :texts
  has_many :email_templates
  has_many :coupons
  has_many :invites
  has_many :installment_plans
  has_many :orders
  has_many :program_modules
  has_many :program_participants, -> { where active: true }
  has_many :users, through: :program_participants
  has_many :uploads

  def text(text_type)
    text = texts.find_by(text_type: text_type)
    text ? text.value : nil
  end

  def email_template(email_type)
    text = email_templates.find_by(email_type: email_type)
  end

  def check_coupon(code)
    return nil if code.blank?
    coupons.find_by(code: code)
  end

  def apply_coupon(coupon)
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
