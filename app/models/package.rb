class Package < ActiveRecord::Base
  has_many :events
  has_many :attendees, through: 'events'
end
