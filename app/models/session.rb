class Session < ActiveRecord::Base
  default_scope { order(starts_at: :asc) }

  has_many :attendees, -> { order(:created_at) }
  has_many :members, through: 'attendees'

  has_one :teacher, through: 'guest'
  has_many :guests
  belongs_to :event
  belongs_to :location

  after_save :create_sku, if: :registerable?

  monetize :ticket_cost, as: :cost, with_model_currency: :ticket_currency, allow_nil: true

  def registerable?
    Time.now.in_time_zone('Eastern Time (US & Canada)').to_date < starts_at.to_date && !ticket_cost.blank?
  end

  def highlight?
    now = Time.now.utc - 4.hour
    now + 2.hour >= starts_at && now - 1.hour <= ends_at
  end

  def overlaps?(other)
    (starts_at < other.ends_at) && (other.starts_at < ends_at)
  end

  def create_sku
    if sku.blank?
      SyncSkusService.new(self).create!
    end
    true
  end

  def net_income
    attendees.map(&:amount_paid).reduce(:+) || Money.new(0, 'usd')
  end

  def guests_by_role
    guests.group_by { |guest| guest.role }.values
  end
end
