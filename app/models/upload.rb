class Upload < ActiveRecord::Base
  belongs_to :site
  belongs_to :program
  validates :site_id, presence: true
  validates :program_id, presence: true
end
