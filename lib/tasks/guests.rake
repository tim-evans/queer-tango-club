namespace :guests do
  desc "Fix guests with references to multiple sessions"
  task :fix_references => :environment do
    Guest.all.each do |guest|
      sessions = Session.where(guest_id: guest.id)
      if sessions.count > 1
        sessions.offset(1).each do |session|
          session.guests.create(
            teacher: guest.teacher,
            role: guest.role
          )
        end
      end
    end
  end
end
