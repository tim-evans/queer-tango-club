class ItineraryService
  def initialize(sessions)
    @sessions = sessions
  end

  def to_civil(date)
    DateTime.civil(date.year,
                   date.month,
                   date.day,
                   date.hour,
                   date.min,
                   0,
                   '-4')
  end

  def events
    @sessions.map do |session|
      event = Icalendar::Event.new
      event.dtstart = session.starts_at
      event.dtend = session.ends_at
      event.summary = "#{session.event.title} / #{session.title}"
      event.description = session.description
      if session.location
        event.location = session.location.to_s
        event.geo = [session.location.latitude.to_f, session.location.longitude.to_f]
      end
      event.organizer = Icalendar::Values::CalAddress.new("mailto:#{Rails.application.secrets.email_address}", cn: "Queer Tango Club")
      event
    end
  end

  def itinerary
    cal = Icalendar::Calendar.new
    events.each { |event| cal.add_event(event) }
    cal.to_ical
  end
end
