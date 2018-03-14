class Session < ActiveRecord::Base
  default_scope { order(starts_at: :asc) }

  has_many :attendees, -> { order(:created_at) }
  has_many :members, through: 'attendees'

  has_one :teacher, through: 'guest'
  has_many :guests
  belongs_to :event
  belongs_to :location

  accepts_nested_attributes_for :guests, reject_if: :all_blank

  validates_presence_of :title, :starts_at, :ends_at

  monetize :ticket_cost, as: :cost, with_model_currency: :ticket_currency, allow_nil: true

  def registerable?
    (event.id == 45 || event.id == 48) && DateTime.current < starts_at
  end

  def highlight?
    now = DateTime.current
    now + 2.hour >= starts_at && now - 1.hour <= ends_at
  end

  def overlaps?(other)
    (starts_at < other.ends_at) && (other.starts_at < ends_at)
  end

  def display_cost
    if cost.try(:zero?)
      ''
    else
      cost.try(:format, no_cents_if_whole: true)
    end
  end

  def display_cost=(money)
    Monetize.assume_from_symbol = true
    cost = Monetize.parse(money)
    if cost.zero?
      self.cost = nil
    else
      self.cost = cost
    end
  end

  def net_income
    attendees.map(&:amount_paid).reduce(:+) || Money.new(0, 'usd')
  end

  def guests_by_role
    guests.group_by { |guest| guest.role }.values
  end
end
