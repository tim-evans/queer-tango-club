# coding: utf-8
# This file should contain all the record creation needed to seed the database with its default values.
# The data can then be loaded with the rake db:seed (or created alongside the db with db:setup).
#
# Examples:
#
#   cities = City.create([{ name: 'Chicago' }, { name: 'Copenhagen' }])
#   Mayor.create(name: 'Emanuel', city: cities.first)

lgbt_center = Location.create({
  name: 'The Lesbian, Gay, Bisexual, & Transgender Community Center',
  address_line: '207 W 13th St',
  extended_address: 'Room 213',
  city: 'New York',
  region_code: 'NY',
  postal_code: '10011'
})

Location.create({
  name: 'The Bureau of General Services: Queer Division',
  address_line: '207 W 13th St',
  extended_address: 'Room 210',
  city: 'New York',
  region_code: 'NY',
  postal_code: '10011',
  event_location: lgbt_center,
  safe_space: true
})

Location.create({
  name: 'Think Coffee',
  address_line: '207 W 13th St',
  city: 'New York',
  region_code: 'NY',
  postal_code: '10011',
  event_location: lgbt_center,
  safe_space: true
})

sheen_center = Location.create({
  name: 'The Sheen Center',
  address_line: '18 Bleecker Street',
  extended_address: 'Studios A & B',
  city: 'New York',
  region_code: 'NY',
  postal_code: '10012'
})

Location.create({
  name: 'Housing Works',
  address_line: '126 Crosby Street',
  city: 'New York',
  region_code: 'NY',
  postal_code: '10012',
  event_location: sheen_center,
  safe_space: true
})

Location.create({
  name: 'Lafayette',
  address_line: '380 Lafayette Street',
  city: 'New York',
  region_code: 'NY',
  postal_code: '10003',
  event_location: sheen_center
})

Location.create({
  name: 'La Columbe Torrefaction',
  address_line: '400 Lafayette Street',
  city: 'New York',
  region_code: 'NY',
  postal_code: '10012',
  event_location: sheen_center
})


inauguration = Milonga.create({
  title: 'Inaugural Milonga',
  starts_at: DateTime.parse("2015-10-17"),
  ends_at: DateTime.parse("2015-10-17")
})

alter_ego = Milonga.create({
  title: 'Alter Ego',
  starts_at: DateTime.parse("2015-11-21"),
  ends_at: DateTime.parse("2015-11-21")
})

holiday_milonga = Milonga.create({
  title: 'Holiday Milonga',
  starts_at: DateTime.parse("2015-12-19"),
  ends_at: DateTime.parse("2015-12-19")
})

marc_vanzwoll = Teacher.create({
  name: 'Marc Vanzwoll',
  bio: 'Marc Vanzwoll has developed his approach to tango, which blends close connection and body awareness with individuality and balance by each partner, in San Francisco and Boston.

Since moving to the East Coast, he has been teaching in Boston and Cape Cod. This year he was honored to teach Intercambio at the NY Queer Tango Weekend and taught with Brigitta Winkler in performance seminars exploring expression, meaning, and emotion in tango at the International QueerTango Festival Berlin. While in Boston, Marc created and co-hosted “Letras de Tango”, focusing on the poetry and meaning of tango lyrics. He also co-authored and co-taught the workshops “Axis Awareness”, “Lady Leaders Workshop”, and “Men’s Following Technique”. Marc is passionate about Argentine Tango, and encourages everyone to participate.'
})

workshop = Workshop.create({
  title: 'Workshops with Marc Vanzwoll',
  starts_at: DateTime.parse("2016-01-30"),
  ends_at: DateTime.parse("2016-01-31")
})


guest =  Guest.create({
  teacher: marc_vanzwoll,
  role: 'Teacher'
})

Session.create({
  title: 'From Walking to Dancing',
  description: 'Take the ho-hum out of your walk, and dance. 4 ways to perfect your cross system walking while developing your Jedi tango powers.',
  starts_at: DateTime.parse("2016-01-30 13:00"),
  ends_at: DateTime.parse("2016-01-30 14:30"),
  guest: guest,
  event: workshop,
  location: sheen_center
})

Session.create({
  title: 'Not Your Average Intercambio',
  description: 'Switch roles with invisible transitions. Diversify, and make the Leader/Follower relationship dynamic. Your tango will never be the same.',
  starts_at: DateTime.parse("2016-01-30 15:00"),
  ends_at: DateTime.parse("2016-01-30 16:30"),
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
  guest: guest,
  event: workshop,
  location: sheen_center
})

Session.create({
  title: 'Ocho Cortado Reloaded',
  description: 'Make it fun for yourself and your partner. Learn how to ocho cortado, then hack it. Small spaces? No problem. Hey Leaders and Followers, get creative!',
  starts_at: DateTime.parse("2016-01-31 15:00"),
  ends_at: DateTime.parse("2016-01-31 16:30"),
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
