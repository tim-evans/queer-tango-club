class Event < ActiveRecord::Base
  has_many :sessions
  has_many :guests,    through: 'sessions'
  has_many :attendees, through: 'sessions'

  belongs_to :location
end
