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
  description: "We are pleased to have the very lovely and creative dancer, performer and teacher, Rebecca Shulman as our very first guest teacher. She will be teaching a Beginner's class from 6:30 to 7:30pm right before the inaugural Milonga. Our DJ for the evening is the multi-talented Lexa Roséan."
})

inauguration.cover_photos.create({
  attachment: File.open("#{photos_dir}/inaugural_cover.png"),
  title: 'Inaugural Milonga'
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

s = Session.create({
  title: "Beginner's Class",
  starts_at: DateTime.parse("2015-10-17 18:30"),
  ends_at: DateTime.parse("2015-10-17 19:30"),
  event: inauguration,
  location: lgbt_center
})

s.guests.create({
  teacher: rebecca_shulman,
  role: 'Teacher'
})

s = Session.create({
  title: "Milonga",
  starts_at: DateTime.parse("2015-10-17 19:30"),
  ends_at: DateTime.parse("2015-10-17 21:45"),
  event: inauguration,
  location: lgbt_center
})

s.guests.create({
  teacher: lexa_rosean,
  role: 'DJ'
})

alter_ego = Milonga.create({
  title: 'Alter Ego',
  starts_at: DateTime.parse("2015-11-21"),
  ends_at: DateTime.parse("2015-11-21"),
  description: "With the change of seasons, the passing of halloween and the coming of thanksgiving, let us celebrate the duality of human nature, embrace our secret identities, and give free rein to our other selves. Let your Alter Ego loose on November 21st. Express, display, present your alter ego as freely as you desire in whatever shape or form it wishes to manifest!"
})

alter_ego.cover_photos.create({
  attachment: File.open("#{photos_dir}/alter_ego_cover.png"),
  title: 'Alter Ego'
})

s = Session.create({
  title: "Class",
  starts_at: DateTime.parse("2015-11-21 18:30"),
  ends_at: DateTime.parse("2015-11-21 19:30"),
  event: alter_ego,
  location: lgbt_center
})

s.guests.create({
  teacher: walter_perez,
  role: 'Teacher'
})

s =Session.create({
  title: "Milonga",
  starts_at: DateTime.parse("2015-11-21 19:30"),
  ends_at: DateTime.parse("2015-11-21 21:45"),
  event: alter_ego,
  location: lgbt_center
})

s.guests.create({
  teacher: walter_perez,
  role: 'DJ'
})

holiday_milonga = Milonga.create({
  title: 'Holiday Milonga',
  starts_at: DateTime.parse("2015-12-19"),
  ends_at: DateTime.parse("2015-12-19"),
  description: "These two ladies need no introduction!!! You ought to find out for yourself on Dec 19th if you don't know why.\n\nWe can't think of a better way to spend the third Saturday of December with two of the most lovely tangueras in New York City. Come and keep warm with your Queer Tango family before the turn of the year!"
})

holiday_milonga.cover_photos.create({
  attachment: File.open("#{photos_dir}/holiday_cover.png"),
  title: 'Holiday Milonga'
})

s = Session.create({
  title: "Class",
  starts_at: DateTime.parse("2015-12-19 18:15"),
  ends_at: DateTime.parse("2015-12-19 19:15"),
  event: holiday_milonga,
  location: lgbt_center
})

s.guests.create({
  teacher: maria_jose,
  role: 'Teacher'
})

s = Session.create({
  title: "Milonga",
  starts_at: DateTime.parse("2015-12-19 19:30"),
  ends_at: DateTime.parse("2015-12-19 21:45"),
  event: holiday_milonga,
  location: lgbt_center
})

s.guests.create({
  teacher: meg_farrell,
  role: 'DJ'
})

milonga_janus = Milonga.create({
  title: 'Milonga Janus',
  starts_at: DateTime.parse("2016-01-16"),
  ends_at: DateTime.parse("2016-01-16"),
  description: "This January 2016 we are honoring Janus, a symbol of new beginnings and transitions. We shall enter a new doorway, and tango our way through this passage of change in warmth and embrace with one another.\n\nLeading us with her spellbinding moves is a pioneer of Queer Tango in New York, Lexa Roséan. Do not miss this rare opportunity to learn from this bewitching figure of our community.\n\nOur DJ baton will be in the hands of Edit Farsi. We are extremely excited to 'out' her as not only a great leader on the dance floor but also a terrific Dj."
})

milonga_janus.cover_photos.create({
  attachment: File.open("#{photos_dir}/janus_cover.png"),
  title: 'Milonga Janus'
})

s = Session.create({
  title: "Class",
  starts_at: DateTime.parse("2016-01-16 18:15"),
  ends_at: DateTime.parse("2016-01-16 19:15"),
  event: milonga_janus,
  location: lgbt_center
})

s.guests.create({
  teacher: lexa_rosean,
  role: 'Teacher'
})

s = Session.create({
  title: "Milonga",
  starts_at: DateTime.parse("2016-01-16 19:15"),
  ends_at: DateTime.parse("2016-01-16 21:45"),
  event: milonga_janus,
  location: lgbt_center
})

s.guests.create({
  teacher: edit_fasi,
  role: 'DJ'
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
  title: 'Marc Vanzwoll',
  starts_at: DateTime.parse("2016-01-30"),
  ends_at: DateTime.parse("2016-01-31")
})

workshop.cover_photos.create({
  attachment: File.open("#{photos_dir}/marc_cover.png"),
  title: 'Marc Vanzwoll'
})

s = Session.create({
  title: 'From Walking to Dancing',
  description: 'Take the ho-hum out of your walk, and dance. 4 ways to perfect your cross system walking while developing your Jedi tango powers.',
  starts_at: DateTime.parse("2016-01-30 13:00"),
  ends_at: DateTime.parse("2016-01-30 14:30"),
  ticket_cost: 3500,
  ticket_currency: 'usd',
  max_attendees: 30,
  event: workshop,
  location: sheen_center
})

s.guests.create({
  teacher: marc_vanzwoll,
  role: 'Teacher'
})

s = Session.create({
  title: 'Not Your Average Intercambio',
  description: 'Switch roles with invisible transitions. Diversify, and make the Leader/Follower relationship dynamic. Your tango will never be the same.',
  starts_at: DateTime.parse("2016-01-30 15:00"),
  ends_at: DateTime.parse("2016-01-30 16:30"),
  ticket_cost: 3500,
  ticket_currency: 'usd',
  max_attendees: 30,
  event: workshop,
  location: sheen_center
})

s.guests.create({
  teacher: marc_vanzwoll,
  role: 'Teacher'
})

Session.create({
  title: 'Practica',
  description: "Practice what you've learned after workshops or join us for some dancing.",
  starts_at: DateTime.parse("2016-01-30 16:30"),
  ends_at: DateTime.parse("2016-01-30 18:00"),
  event: workshop,
  location: sheen_center
})

s = Session.create({
  title: 'Cadena for You and for Me!',
  description: 'A classic pattern to brighten up your tango. 4 basic steps linked together with identical foot work pattern for both Leader and Follower. Find out why this pattern travels or stays in place, and is perfect for switching roles seamlessly',
  starts_at: DateTime.parse("2016-01-31 13:00"),
  ends_at: DateTime.parse("2016-01-31 14:30"),
  ticket_cost: 3500,
  ticket_currency: 'usd',
  max_attendees: 30,
  event: workshop,
  location: sheen_center
})

s.guests.create({
  teacher: marc_vanzwoll,
  role: 'Teacher'
})

s = Session.create({
  title: 'Ocho Cortado Reloaded',
  description: 'Make it fun for yourself and your partner. Learn how to ocho cortado, then hack it. Small spaces? No problem. Hey Leaders and Followers, get creative!',
  starts_at: DateTime.parse("2016-01-31 15:00"),
  ends_at: DateTime.parse("2016-01-31 16:30"),
  ticket_cost: 3500,
  ticket_currency: 'usd',
  max_attendees: 30,
  event: workshop,
  location: sheen_center
})

s.guests.create({
  teacher: marc_vanzwoll,
  role: 'Teacher'
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
})

bienvenidos.cover_photos.create({
  title: 'Milonga Bienvenidos',
  attachment: File.open("#{photos_dir}/bienvenidos_cover.png")
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

s = Session.create({
  title: "Milonga",
  starts_at: DateTime.parse("2016-01-30 20:00"),
  ends_at: DateTime.parse("2016-01-30 23:00"),
  event: bienvenidos,
  location: bluebird
})

s.guests.create({
  teacher: walter_perez,
  role: 'DJ'
})

fever = Milonga.create({
  title: 'Milonga Fever',
  starts_at: DateTime.parse("2016-02-20"),
  ends_at: DateTime.parse("2016-02-20"),
  description: "Catch the infectious personality, and style of our guest teachers Sidney Grant and Claudio Marcelo Vidal! Be inoculated by their joie de vivre so the only fever you'll catch for the rest of the year"
})

fever.cover_photos.create({
  attachment: File.open("#{photos_dir}/fever_cover.png"),
  title: 'Milonga Fever'
})

sid_and_claudio = Teacher.create({
  name: "Sidney Grant & Claudio Marcelo Vidal",
  url: "www.ballroombasix.org",
  bio: "Sidney Grant‘s 25-year career in Ballroom, Latin & Tango has included performances and choreographies on and off Broadway, and in TV and Film. He has taught extensively in the U.S. (Boston, Chicago, Phoenix, Memphis), as well as globally in Central / South America, Europe and Asia, most notably Hong Kong. He is Founder / Artistic Director of the acclaimed arts program BALLROOM BASIX, for which he was named New Yorker of the Week on NY1 news. In just 5 years, Grant and his dedicated team of Teaching Artists have taught tango, among other partner dances, to over 6,000 schoolchildren.

Sid was the 2011 USA Argentine Tango Salon Champion in NYC, the 1st time an openly gay man ever won. He and partner Gayle Madeira donated their winnings to BALLROOM BASIX. In 2012, he was Guest of Honor (with Walter and Leo) at the 6th International Queer Tango Festival in BA. More recently, he judged Argentine Tango at both the World Gay Games as well as April Follies, the largest same-sex dance competition in the US, where he performed his TIN MAN TANGO with Claudio&hellip; as Dorothy!

Claudio Marcelo Vidal was the 1st man in the history of the Campeonato Mundial (World Tango Championships) to wear heels as a male follower. His story was featured in Clarin and Nación, Argentina’s largest newspapers. A nurse for terminally ill children in Buenos Aires by day, Claudio has become an integral part of Queer Tango ever since his first tanda with partner Sid Grant 7 years ago. Since that time, the two have taught and performed in BA, New York and San Francisco."
})

Photo.create({
  teacher: sid_and_claudio,
  attachment: File.open("#{photos_dir}/sidney_and_claudio.jpg")
})

s = Session.create({
  title: "Class",
  starts_at: DateTime.parse("2016-02-20 18:15"),
  ends_at: DateTime.parse("2015-02-20 19:15"),
  event: fever,
  location: lgbt_center
})

s.guests.create({
  teacher: sid_and_claudio,
  role: 'Teacher'
})

Session.create({
  title: "Milonga",
  starts_at: DateTime.parse("2016-02-20 19:15"),
  ends_at: DateTime.parse("2016-02-20 21:45"),
  event: fever,
  location: lgbt_center
})


soledad = Teacher.create({
  name: 'Soledad Nani',
  bio: 'Soledad Nani began dancing tango at 21 and, from the beginning, learned to dance both roles. She graduated from the Educational Tango Center of Buenos Aires (the Tango University) and among her early influential teachers were Rodolfo Dinzel, Olga Besio, and Juan Miguel Expósito.

Since 2004, Soledad has taught in various cultural centers and State community programs, teaching tango at public schools and public heath centers for seniors, young people, children, and women in situations of gender violence and domestic abuse. “Tango by and for Women,” a rare concept at the time, was one of her early collaborations.

She became an adjunct teacher at Espacio Tango Queer in Buenos Aires in 2008 and now teaches regularly at the Queer Tango Festival in Buenos Aires and the weekly milonga Tango Queer de Buenos Aires. She has performed at a variety of milongas in Buenos Aires such as Confiteria Ideal, Tango Queer, La Marshall, and Salon Canning. She has also participated in events sponsored by the Argentine National Congress and at other cultural venues.

Soledad is recognized throughout Buenos Aires, in traditional as well as queer settings, as a musical, creative dancer, one of the stunning female leaders of her generation.

In 2012, Soledad began teaching and performing internationally and quickly became a special guest teacher in cities all around the globe: San Francisco Bay Area, Seattle, Boston, Berlin and throughout Germany, Paris, St. Petersburg, and Zurich.

Her perspective of tango is that it is a paired dance with both partners contributing equally to the ensemble. This approach encourages the dancers to produce a balanced and more intense collaboration.'
})

Photo.create({
  teacher: soledad,
  attachment: File.open("#{photos_dir}/soledad_1.jpg")
})

Photo.create({
  teacher: soledad,
  attachment: File.open("#{photos_dir}/soledad_2.jpg")
})

nancy = Teacher.create({
  name: 'Nancy Lavoie',
  url: 'http://avenuetango.com/',
  bio: "Nancy Lavoie has a background in music but was seduced in her very first class by the wonderful expressiveness of Argentinian Tango. She travelled to Argentina to learn from teachers who had been there for the Golden Age of tango to better understand the history, the traditions and the language.

In 1995 she started the very first Tango school in Québec: l'Avenue Tango. She teaches there to this day and organizes special classes and workshops with teachers from Europe and Argentina. In 2001 she created the very first improv-tango team in Buenos Aires. In 2005 she, became a member of the collective Tango Discovery, a research in movement group based in Buenos Aires. In 2014 she founded the collective Tango Nomade with Yannick Allen-Vuillet. Together they also lead a new group dedicated to the 20 years of Tango in Québec: Tango Vintage.

Nancy is regularly invited to give workshops and shows in Berlin, San Fransisco, Buenos Aires, Rome, Stockholm, Hamburg, Zurich, Oslo, Paris."
})

Photo.create({
  teacher: nancy,
  attachment: File.open("#{photos_dir}/nancy.jpg")
})

yannick = Teacher.create({
  name: 'Yannick Allen-Vuillet',
  bio: "Yannick started dancing Tango at 17 and immediately fell in love with it's charm and expressiveness of it's language. From the beginning of his education he learned to master not only the role of the lead but also that of following. This gave him a deeper and richer understanding of Tango. He started to travel early for Tango, wanting to see new places and perfect his dance. Four years later he regularly teaches with his partner Nancy Lavoie, while also performing in numerous shows in Québec, Montreal, Porto, and Berlin, and also participated in the artistic direction of the TER Tango et Répiblica Tanguera Shows. Coming from a visual arts background, his mixed artistic sensibility informs all his creations."
})

Photo.create({
  teacher: yannick,
  attachment: File.open("#{photos_dir}/yannick.jpg")
})

workshop = Workshop.create({
  title: 'Soledad Nani',
  starts_at: DateTime.parse("2016-03-17"),
  ends_at: DateTime.parse("2016-03-20")
})

workshop.privates.create({
  teacher: soledad,
  description: "Soledad Nani is available for private lessons. Lessons are $90 each, with a discounted rate of $75 per each lesson if you book three or more. This does not include the floor fee.",
  starts_at: DateTime.parse("2016-03-17"),
  ends_at: DateTime.parse("2016-03-21")
})

workshop.cover_photos.create({
  attachment: File.open("#{photos_dir}/soledad_cover.jpg"),
  title: 'Soledad Nani'
})

workshop.cover_photos.create({
  attachment: File.open("#{photos_dir}/nancy_yannick_cover.png"),
  title: 'Nancy Lavoie & Yannick Allen-Vuillet'
})

alchemical = Location.create({
  name: 'Alchemical Studios',
  address_line: '104 W 14th St',
  city: 'New York',
  region_code: 'NY',
  postal_code: '10011',
  photo: File.open("#{photos_dir}/alchemical.png")
})

s = Session.create({
  title: 'Meet & Greet Practica',
  starts_at: DateTime.parse("2016-03-17 19:00"),
  ends_at: DateTime.parse("2016-03-17 22:00"),
  event: workshop,
  location: alchemical
})

s.guests.create({
  teacher: soledad,
  role: 'Teacher'
})

s = Session.create({
  title: 'Pre-Milonga Class&mdash; Essentials of Walking',
  starts_at: DateTime.parse("2016-03-18 20:00"),
  ends_at: DateTime.parse("2016-03-18 21:00"),
  event: workshop
})

s.guests.create({
  teacher: soledad,
  role: 'Teacher'
})

s = Session.create({
  title: 'Milonga Queer Fundraiser',
  starts_at: DateTime.parse("2016-03-18 21:00"),
  ends_at: DateTime.parse("2016-03-19 01:00"),
  event: workshop
})

s.guests.create({
  teacher: soledad,
  role: 'Performer'
})

s.guests.create({
  teacher: nancy,
  role: 'Performer'
})

s = Session.create({
  title: 'Communication',
  starts_at: DateTime.parse("2016-03-19 13:00"),
  ends_at: DateTime.parse("2016-03-19 14:30"),
  event: workshop
})

s.guests.create({
  teacher: soledad,
  role: 'Teacher'
})

s = Session.create({
  title: 'Pivot Dynamic',
  starts_at: DateTime.parse("2016-03-19 13:00"),
  ends_at: DateTime.parse("2016-03-19 14:30"),
  event: workshop
})

s.guests.create({
  teacher: nancy,
  role: 'Teacher'
})

s.guests.create({
  teacher: yannick,
  role: 'Teacher'
})

s = Session.create({
  title: 'Sensibility',
  starts_at: DateTime.parse("2016-03-19 15:00"),
  ends_at: DateTime.parse("2016-03-19 16:30"),
  event: workshop
})

s.guests.create({
  teacher: soledad,
  role: 'Teacher'
})

s = Session.create({
  title: 'Keys to Improvisation',
  starts_at: DateTime.parse("2016-03-19 15:00"),
  ends_at: DateTime.parse("2016-03-19 16:30"),
  event: workshop
})

s.guests.create({
  teacher: nancy,
  role: 'Teacher'
})

s.guests.create({
  teacher: yannick,
  role: 'Teacher'
})

s = Session.create({
  title: 'Practica',
  starts_at: DateTime.parse("2016-03-19 16:30"),
  ends_at: DateTime.parse("2016-03-19 18:00"),
  event: workshop
})

s = Session.create({
  title: 'Pre-Milonga Class&mdash; Essentials 8&rsquo;s',
  starts_at: DateTime.parse("2016-03-19 20:00"),
  ends_at: DateTime.parse("2016-03-19 21:00"),
  event: workshop
})

s.guests.create({
  teacher: soledad,
  role: 'Teacher'
})

s = Session.create({
  title: 'Milonga Equinox',
  starts_at: DateTime.parse("2016-03-19 21:00"),
  ends_at: DateTime.parse("2016-03-19 24:00"),
  event: workshop
})

s = Session.create({
  title: 'Improvisation without roles',
  starts_at: DateTime.parse("2016-03-20 13:00"),
  ends_at: DateTime.parse("2016-03-20 14:30"),
  event: workshop
})

s.guests.create({
  teacher: soledad,
  role: 'Teacher'
})

s = Session.create({
  title: 'Entire Body',
  starts_at: DateTime.parse("2016-03-20 15:00"),
  ends_at: DateTime.parse("2016-03-20 16:30"),
  event: workshop
})

s.guests.create({
  teacher: soledad,
  role: 'Teacher'
})
