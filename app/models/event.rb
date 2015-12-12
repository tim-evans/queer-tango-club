class Event < ActiveRecord::Base
  has_many :attendees
  has_many :members, through: 'attendees'

  # An event may be part of a package deal
  belongs_to :package

  validates :type, inclusion: { in: %(milonga workshop) }
end
