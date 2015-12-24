class Session < ActiveRecord::Base
  has_many :attendees
  has_many :guests
  has_many :teachers, through: 'guests'
  has_many :members, through: 'attendees'

  belongs_to :event
  belongs_to :location
end
