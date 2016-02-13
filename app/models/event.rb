class Event < ActiveRecord::Base
  has_attached_file :cover_photo, styles: {
                      grayscale: { convert_options: '-colorspace Gray -separate -average -modulate 110%' }
                    }
  validates_attachment_content_type :cover_photo, content_type: %w(image/jpeg image/jpg image/png)

  has_many :sessions
  has_many :guests, -> { distinct }, through: 'sessions'
  has_many :attendees, through: 'sessions'
  has_many :photos

  has_many :locations, -> { distinct }, through: 'sessions'

  scope :upcoming, -> { where('ends_at > ?', Time.now) }
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
end
