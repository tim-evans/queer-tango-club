class Session < ActiveRecord::Base
  has_many :attendees
  has_many :members, through: 'attendees'

  has_one :teacher, through: 'guest'
  has_many :guests
  belongs_to :event
  belongs_to :location

  after_create :create_sku, if: :registerable?

  def registerable?
    !ticket_cost.blank?
  end

  def overlaps?(other)
    (starts_at <= other.ends_at) && (other.starts_at >= ends_at)
  end

  def create_sku
    SyncSkusService.new(self).create!
  end
end
