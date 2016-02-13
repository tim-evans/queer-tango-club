# coding: utf-8
# This file should contain all the record creation needed to seed the database with its default values.
# The data can then be loaded with the rake db:seed (or created alongside the db with db:setup).
#
# Examples:
#
#   cities = City.create([{ name: 'Chicago' }, { name: 'Copenhagen' }])
#   Mayor.create(name: 'Emanuel', city: cities.first)

photos_dir = Dir.pwd + '/db/seed'

lgbt_center = Location.create({
  name: 'The Lesbian, Gay, Bisexual, & Transgender Community Center',
  address_line: '207 W 13th St',
  extended_address: 'Room 213',
  city: 'New York',
  region_code: 'NY',
  postal_code: '10011',
  photo: File.open("#{photos_dir}/the_center.png")
})

Location.create({
  name: 'The Bureau of General Services: Queer Division',
  address_line: '207 W 13th St',
  extended_address: 'Room 210',
  city: 'New York',
  region_code: 'NY',
  postal_code: '10011',
  event_location: lgbt_center,
  safe_space: true,
  photo: File.open("#{photos_dir}/the_bureau.jpg")
})

Location.create({
  name: 'Think Coffee',
  address_line: '207 W 13th St',
  city: 'New York',
  region_code: 'NY',
  postal_code: '10011',
  event_location: lgbt_center,
  safe_space: true,
  photo: File.open("#{photos_dir}/think_coffee.jpg")
})

sheen_center = Location.create({
  name: 'The Sheen Center',
  address_line: '18 Bleecker Street',
  extended_address: 'Studios A & B',
  city: 'New York',
  region_code: 'NY',
  postal_code: '10012',
  photo: File.open("#{photos_dir}/sheen_center.png")
})

Location.create({
  name: 'Housing Works',
  address_line: '126 Crosby Street',
  city: 'New York',
  region_code: 'NY',
  postal_code: '10012',
  event_location: sheen_center,
  safe_space: true,
  photo: File.open("#{photos_dir}/housing_works.png")
})

Location.create({
  name: 'Lafayette',
  address_line: '380 Lafayette Street',
  city: 'New York',
  region_code: 'NY',
  postal_code: '10003',
  event_location: sheen_center,
  photo: File.open("#{photos_dir}/lafayette.png")
})

Location.create({
  name: 'La Columbe Torrefaction',
  address_line: '400 Lafayette Street',
  city: 'New York',
  region_code: 'NY',
  postal_code: '10012',
  event_location: sheen_center,
  photo: File.open("#{photos_dir}/la_colombe.png")
})


inauguration = Milonga.create({
  title: 'Inaugural Milonga',
  starts_at: DateTime.parse("2015-10-17"),
  ends_at: DateTime.parse("2015-10-17"),
  cover_photo: File.open("#{photos_dir}/inaugural_cover.png"),
  description: "We are pleased to have the very lovely and creative dancer, performer and teacher, Rebecca Shulman as our very first guest teacher. She will be teaching a Beginner's class from 6:30 to 7:30pm right before the inaugural Milonga. Our DJ for the evening is the multi-talented Lexa Roséan."
})

rebecca_shulman = Teacher.create({
  name: 'Rebecca Shulman',
  url: 'http://rebeccatango.com/'
})

Photo.create({
  teacher: rebecca_shulman,
  attachment: File.open("#{photos_dir}/rebecca_shulman.png")
})

lexa_rosean = Teacher.create({
  name: 'Lexa Roséan',
  url: 'http://www.lexarosean.com/tango.html'
})

Photo.create({
  teacher: lexa_rosean,
  attachment: File.open("#{photos_dir}/lexa_rosean.png")
})

walter_perez = Teacher.create({
  name: 'Walter Perez'
})

Photo.create({
  teacher: walter_perez,
  attachment: File.open("#{photos_dir}/walter_perez.jpg")
})

maria_jose = Teacher.create({
  name: 'María José Sosa'
})

Photo.create({
  teacher: maria_jose,
  attachment: File.open("#{photos_dir}/maria_jose.jpg")
})

meg_farrell = Teacher.create({
  name: 'Meg Farrell',
})

Photo.create({
  teacher: meg_farrell,
  attachment: File.open("#{photos_dir}/meg_farrell.jpg")
})

edit_fasi = Teacher.create({
  name: 'Edit Fasi',
})

Photo.create({
  teacher: edit_fasi,
  attachment: File.open("#{photos_dir}/edit_fasi.jpg")
})

Session.create({
  title: "Beginner's Class",
  starts_at: DateTime.parse("2015-10-17 18:30"),
  ends_at: DateTime.parse("2015-10-17 19:30"),
  guest: Guest.create({
    teacher: rebecca_shulman,
    role: 'Teacher'
  }),
  event: inauguration,
  location: lgbt_center
})

Session.create({
  title: "Milonga",
  starts_at: DateTime.parse("2015-10-17 19:30"),
  ends_at: DateTime.parse("2015-10-17 21:45"),
  guest: Guest.create({
    teacher: lexa_rosean,
    role: 'DJ'
  }),
  event: inauguration,
  location: lgbt_center
})

alter_ego = Milonga.create({
  title: 'Alter Ego',
  starts_at: DateTime.parse("2015-11-21"),
  ends_at: DateTime.parse("2015-11-21"),
  cover_photo: File.open("#{photos_dir}/alter_ego_cover.png"),
  description: "With the change of seasons, the passing of halloween and the coming of thanksgiving, let us celebrate the duality of human nature, embrace our secret identities, and give free rein to our other selves. Let your Alter Ego loose on November 21st. Express, display, present your alter ego as freely as you desire in whatever shape or form it wishes to manifest!"
})

Session.create({
  title: "Class",
  starts_at: DateTime.parse("2015-11-21 18:30"),
  ends_at: DateTime.parse("2015-11-21 19:30"),
  guest: Guest.create({
    teacher: walter_perez,
    role: 'Teacher'
  }),
  event: alter_ego,
  location: lgbt_center
})

Session.create({
  title: "Milonga",
  starts_at: DateTime.parse("2015-11-21 19:30"),
  ends_at: DateTime.parse("2015-11-21 21:45"),
  guest: Guest.create({
    teacher: walter_perez,
    role: 'DJ'
  }),
  event: alter_ego,
  location: lgbt_center
})

holiday_milonga = Milonga.create({
  title: 'Holiday Milonga',
  starts_at: DateTime.parse("2015-12-19"),
  ends_at: DateTime.parse("2015-12-19"),
  cover_photo: File.open("#{photos_dir}/holiday_cover.png"),
  description: "These two ladies need no introduction!!! You ought to find out for yourself on Dec 19th if you don't know why.\n\nWe can't think of a better way to spend the third Saturday of December with two of the most lovely tangueras in New York City. Come and keep warm with your Queer Tango family before the turn of the year!"
})

Session.create({
  title: "Class",
  starts_at: DateTime.parse("2015-12-19 18:15"),
  ends_at: DateTime.parse("2015-12-19 19:15"),
  guest: Guest.create({
    teacher: maria_jose,
    role: 'Teacher'
  }),
  event: holiday_milonga,
  location: lgbt_center
})

Session.create({
  title: "Milonga",
  starts_at: DateTime.parse("2015-12-19 19:30"),
  ends_at: DateTime.parse("2015-12-19 21:45"),
  guest: Guest.create({
    teacher: meg_farrell,
    role: 'DJ'
  }),
  event: holiday_milonga,
  location: lgbt_center
})

milonga_janus = Milonga.create({
  title: 'Milonga Janus',
  starts_at: DateTime.parse("2016-01-16"),
  ends_at: DateTime.parse("2016-01-16"),
  cover_photo: File.open("#{photos_dir}/janus_cover.png"),
  description: "This January 2016 we are honoring Janus, a symbol of new beginnings and transitions. We shall enter a new doorway, and tango our way through this passage of change in warmth and embrace with one another.\n\nLeading us with her spellbinding moves is a pioneer of Queer Tango in New York, Lexa Roséan. Do not miss this rare opportunity to learn from this bewitching figure of our community.\n\nOur DJ baton will be in the hands of Edit Farsi. We are extremely excited to 'out' her as not only a great leader on the dance floor but also a terrific Dj."
})

Session.create({
  title: "Class",
  starts_at: DateTime.parse("2016-01-16 18:15"),
  ends_at: DateTime.parse("2016-01-16 19:15"),
  guest: Guest.create({
    teacher: lexa_rosean,
    role: 'Teacher'
  }),
  event: milonga_janus,
  location: lgbt_center
})

Session.create({
  title: "Milonga",
  starts_at: DateTime.parse("2016-01-16 19:15"),
  ends_at: DateTime.parse("2016-01-16 21:45"),
  guest: Guest.create({
    teacher: edit_fasi,
    role: 'DJ'
  }),
  event: milonga_janus,
  location: lgbt_center
})

marc_vanzwoll = Teacher.create({
  name: 'Marc Vanzwoll',
  bio: 'Marc Vanzwoll has developed his approach to tango, which blends close connection and body awareness with individuality and balance by each partner, in San Francisco and Boston.

Since moving to the East Coast, he has been teaching in Boston and Cape Cod. This year he was honored to teach Intercambio at the NY Queer Tango Weekend and taught with Brigitta Winkler in performance seminars exploring expression, meaning, and emotion in tango at the International QueerTango Festival Berlin. While in Boston, Marc created and co-hosted “Letras de Tango”, focusing on the poetry and meaning of tango lyrics. He also co-authored and co-taught the workshops “Axis Awareness”, “Lady Leaders Workshop”, and “Men’s Following Technique”. Marc is passionate about Argentine Tango, and encourages everyone to participate.'
})

Photo.create({
  teacher: marc_vanzwoll,
  attachment: File.open("#{photos_dir}/marc_1.jpg")
})

Photo.create({
  teacher: marc_vanzwoll,
  attachment: File.open("#{photos_dir}/marc_4.jpg")
})

workshop = Workshop.create({
  title: 'Workshops with Marc Vanzwoll',
  starts_at: DateTime.parse("2016-01-30"),
  ends_at: DateTime.parse("2016-01-31"),
  cover_photo: File.open("#{photos_dir}/marc_cover.png")
})

guest = Guest.create({
  teacher: marc_vanzwoll,
  role: 'Teacher'
})

Session.create({
  title: 'From Walking to Dancing',
  description: 'Take the ho-hum out of your walk, and dance. 4 ways to perfect your cross system walking while developing your Jedi tango powers.',
  starts_at: DateTime.parse("2016-01-30 13:00"),
  ends_at: DateTime.parse("2016-01-30 14:30"),
  ticket_cost: 3500,
  ticket_currency: 'usd',
  max_attendees: 30,
  guest: guest,
  event: workshop,
  location: sheen_center
})

Session.create({
  title: 'Not Your Average Intercambio',
  description: 'Switch roles with invisible transitions. Diversify, and make the Leader/Follower relationship dynamic. Your tango will never be the same.',
  starts_at: DateTime.parse("2016-01-30 15:00"),
  ends_at: DateTime.parse("2016-01-30 16:30"),
  ticket_cost: 3500,
  ticket_currency: 'usd',
  max_attendees: 30,
  guest: guest,
  event: workshop,
  location: sheen_center
})

Session.create({
  title: 'Practica',
  description: "Practice what you've learned after workshops or join us for some dancing.",
  starts_at: DateTime.parse("2016-01-30 16:30"),
  ends_at: DateTime.parse("2016-01-30 18:00"),
  event: workshop,
  location: sheen_center
})

Session.create({
  title: 'Cadena for You and for Me!',
  description: 'A classic pattern to brighten up your tango. 4 basic steps linked together with identical foot work pattern for both Leader and Follower. Find out why this pattern travels or stays in place, and is perfect for switching roles seamlessly',
  starts_at: DateTime.parse("2016-01-31 13:00"),
  ends_at: DateTime.parse("2016-01-31 14:30"),
  ticket_cost: 3500,
  ticket_currency: 'usd',
  max_attendees: 30,
  guest: guest,
  event: workshop,
  location: sheen_center
})

Session.create({
  title: 'Ocho Cortado Reloaded',
  description: 'Make it fun for yourself and your partner. Learn how to ocho cortado, then hack it. Small spaces? No problem. Hey Leaders and Followers, get creative!',
  starts_at: DateTime.parse("2016-01-31 15:00"),
  ends_at: DateTime.parse("2016-01-31 16:30"),
  ticket_cost: 3500,
  ticket_currency: 'usd',
  max_attendees: 30,
  guest: guest,
  event: workshop,
  location: sheen_center
})

Session.create({
  title: 'Practica',
  description: "Practice what you've learned after workshops or join us for some dancing.",
  starts_at: DateTime.parse("2016-01-31 16:30"),
  ends_at: DateTime.parse("2016-01-31 18:00"),
  event: workshop,
  location: sheen_center
})

bienvenidos = Milonga.create({
  title: 'Milonga Bienvenidos',
  starts_at: DateTime.parse("2016-01-30"),
  ends_at: DateTime.parse("2016-01-30"),
  cover_photo: File.open("#{photos_dir}/bienvenidos_cover.png")
})

bluebird = Location.create({
  name: 'Bluebird Brooklyn Food & Spirits',
  address_line: '504 Flatbush Ave',
  url: 'http://www.bluebirdbrooklyn.com/',
  city: 'Brooklyn',
  region_code: 'NY',
  postal_code: '11225',
  photo: File.open("#{photos_dir}/bluebird.png")
})

Session.create({
  title: "Milonga",
  starts_at: DateTime.parse("2016-01-30 20:00"),
  ends_at: DateTime.parse("2016-01-30 23:00"),
  guest: Guest.create({
    teacher: walter_perez,
    role: 'DJ'
  }),
  event: bienvenidos,
  location: bluebird
})

fever = Milonga.create({
  title: 'Milonga Fever',
  starts_at: DateTime.parse("2016-02-20"),
  ends_at: DateTime.parse("2016-02-20"),
  cover_photo: File.open("#{photos_dir}/fever_cover.png"),
  description: "Catch the infectious personality, and style of our guest teachers Sidney Grant and Claudio Marcelo Vidal! Be inoculated by their joie de vivre so the only fever you'll catch for the rest of the year"
})

sid_and_claudio = Teacher.create({
  name: 'Sidney Grant & Claudio Claudio Marcelo Vidal'
})

Session.create({
  title: "Class",
  starts_at: DateTime.parse("2016-02-20 18:15"),
  ends_at: DateTime.parse("2015-02-20 19:15"),
  guest: Guest.create({
    teacher: sid_and_claudio,
    role: 'Teacher'
  }),
  event: fever,
  location: lgbt_center
})

Session.create({
  title: "Milonga",
  starts_at: DateTime.parse("2016-02-20 19:15"),
  ends_at: DateTime.parse("2016-02-20 21:45"),
  event: fever,
  location: lgbt_center
})
