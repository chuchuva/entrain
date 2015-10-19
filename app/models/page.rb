class Page < ActiveRecord::Base
  belongs_to :site
  belongs_to :program
end
