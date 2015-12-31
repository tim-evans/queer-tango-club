class Member < ActiveRecord::Base
  has_many :attendees
  has_many :sessions, through: :attendees
end
