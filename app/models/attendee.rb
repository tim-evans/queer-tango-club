class Attendee < ActiveRecord::Base
  belongs_to :member
  belongs_to :event
  validates :payment_method, inclusion: { in: %(stripe square cash) }
end
