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

  has_many :locations, -> { distinct }, through: 'sessions'

  scope :upcoming, -> { where('ends_at >= ?', Time.now) }
  scope :historical, -> { where('ends_at < ?', Time.now) }

  def location
    locations.first
  end

  def sessions_by_day
    sessions.order(starts_at: :asc).group_by { |session| session.starts_at.to_date }.values
  end

  def start_time
    sessions.order(starts_at: :asc).limit(1).pluck(:starts_at).first
  end

  def end_time
    sessions.order(ends_at: :desc).limit(1).pluck(:ends_at).first
  end

  def registerable?
    Date.today < start_time.to_date &&
                 sessions.any?(&:registerable?)
  end

  def guests
    teachers = {}
    guests = []
    sessions.order(starts_at: :asc).includes(:guests).each do |session|
      session.guests.where(credited: true).each do |guest|
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
