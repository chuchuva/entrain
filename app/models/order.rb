class Order < ActiveRecord::Base
  belongs_to :site
  belongs_to :program
  belongs_to :user
end
