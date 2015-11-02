class Program < ActiveRecord::Base
  belongs_to :site
  has_many :pages
  has_many :texts
  has_many :orders

  def text(text_type)
    text = texts.find_by(text_type: text_type)
    text ? text.value : nil
  end
end
