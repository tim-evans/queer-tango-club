class Event < ActiveRecord::Base
  # has_attached_file :cover, styles: { jumbo: 'x550', large: 'x400' }

  has_many :sessions
  has_many :guests,    through: 'sessions'
  has_many :attendees, through: 'sessions'

  belongs_to :location
end
