class Attendee < ActiveRecord::Base
  belongs_to :member
  belongs_to :session

  delegate :name, :email, to: :member

  monetize :payment_amount, with_model_currency: :payment_currency,
                            as: 'amount_paid'

  validates :payment_method, inclusion: { in: %w(stripe square cash) }
end
