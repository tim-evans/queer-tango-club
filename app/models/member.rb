class Member < ActiveRecord::Base
  has_many :attendees
  has_many :events, through: :attendees
end
