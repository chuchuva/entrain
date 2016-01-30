class ProgramParticipant < ActiveRecord::Base
  belongs_to :site
  belongs_to :program
  belongs_to :user
  validates :site_id, presence: true
  validates :program_id, presence: true
  validates :user_id, presence: true
end
