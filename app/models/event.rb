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
  has_many :sessions
  has_many :attendees, through: 'sessions'
  has_many :photos
  has_many :cover_photos
  has_many :privates
  has_many :discounts

  has_many :members, through: 'attendees'
  has_many :locations, through: 'sessions'

  scope :upcoming, -> { where('ends_at >= ?', Time.now).includes(:cover_photos) }
  scope :historical, -> { where('ends_at < ?', Time.now).includes(:cover_photos) }

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
    sessions.map(&:net_income).reduce(:+)
  end

  def registerable?
    sessions.any?(&:registerable?)
  end

  def highlight?
    today = Time.now.in_time_zone('Eastern Time (US & Canada)').to_date
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
