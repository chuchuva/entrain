class Program < ActiveRecord::Base
  belongs_to :site
  has_many :orders
end
