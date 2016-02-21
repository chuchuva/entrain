class InstallmentPlan < ActiveRecord::Base
  belongs_to :site
  belongs_to :program
  belongs_to :coupon
end
