class Text < ActiveRecord::Base
  belongs_to :site
  belongs_to :program
  validates_presence_of :value
end
