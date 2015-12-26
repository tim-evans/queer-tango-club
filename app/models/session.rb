class Session < ActiveRecord::Base
  has_many :attendees
  has_many :members, through: 'attendees'

  has_one :teacher, through: 'guest'
  belongs_to :guest
  belongs_to :event
  belongs_to :location
end
