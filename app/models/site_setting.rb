class SiteSetting < ActiveRecord::Base
  belongs_to :site

  validates_presence_of :name
end

# == Schema Information
#
# Table name: site_settings
#
#  id         :integer          not null, primary key
#  name       :string(255)      not null
#  value      :text
#  created_at :datetime         not null
#  updated_at :datetime         not null
#
