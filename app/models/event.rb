class Event < ActiveRecord::Base
  has_attached_file :cover_photo, styles: { jumbo: 'x550', large: 'x400' }
  validates_attachment_content_type :cover_photo, content_type: %w(image/jpeg image/jpg image/png)

  has_many :sessions
  has_many :guests, -> { distinct }, through: 'sessions'
  has_many :attendees, through: 'sessions'
  has_many :photos

  has_many :locations, through: 'sessions'

  def location
    locations.first
  end

  def sessions_by_day
    sessions.group_by { |session| session.starts_at.to_date }.values
  end

  def registerable?
    sessions.any?(&:registerable?)
  end
end
