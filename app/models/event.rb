AggregateGuest = Struct.new(:teacher, :roles) do
  def role
    display_roles = roles.uniq.sort.reverse
    if display_roles.length > 1
      display_roles[0..-2].join(', ') + ' & ' + display_roles[-1]
    else
      display_roles.first
    end
  end

  delegate :name, :url, :bio, :photos, :slug, to: :teacher
end

class Event < ActiveRecord::Base
  has_many :sessions, dependent: :destroy
  has_many :attendees, through: 'sessions'
  has_many :photos
  has_many :cover_photos, dependent: :destroy
  has_many :privates
  has_many :discounts, dependent: :destroy
  has_many :expenses, dependent: :destroy

  has_many :members, through: 'attendees'
  has_many :locations, through: 'sessions'

  scope :published, -> { where(published: true) }
  scope :draft,     -> { where(published: false) }
  scope :upcoming, -> { where('ends_at >= ?', Time.now).includes(:cover_photos) }
  scope :historical, -> { where('ends_at < ?', Time.now).includes(:cover_photos) }

  accepts_nested_attributes_for :sessions, :cover_photos, :discounts

  validates_presence_of :title, :starts_at, :ends_at, :cover_photos
  validates_associated :cover_photos, :sessions

  def location
    locations.first
  end

  def sessions_by_day
    sessions.group_by { |session| session.starts_at.to_date }.values
  end

  def start_time
    sessions.first.starts_at
  end

  def end_time
    sessions.order(ends_at: :desc).limit(1).pluck(:ends_at).first
  end

  def net_income
    sessions.map(&:net_income).reduce(:+) - expenses.map(&:cost).reduce(:+)
  end

  def ticketable?
    published && sessions.any? { |s| s.ticket_cost.present? }
  end

  def registerable?
    published && sessions.any?(&:registerable?)
  end

  def highlight?
    today = Date.current
    today >= starts_at && today <= ends_at
  end

  def guests
    teachers = {}
    guests = []
    sessions.each do |session|
      session.guests.each do |guest|
        next unless guest.credited
        if teachers[guest.teacher.id]
          teachers[guest.teacher.id][:roles] << guest.role
        else
          aggregate = AggregateGuest.new(guest.teacher, [guest.role])
          teachers[guest.teacher.id] = aggregate
          guests << aggregate
        end
      end
    end

    guests
  end
end
