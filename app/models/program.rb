class Program < ActiveRecord::Base
  belongs_to :site
  has_many :pages
  has_many :texts
  has_many :email_templates
  has_many :coupons
  has_many :orders

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
end
