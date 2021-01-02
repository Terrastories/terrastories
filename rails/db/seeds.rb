# This file should contain all the record creation needed to seed the database with its default values.
# The data can then be loaded with the rails db:seed command (or created alongside the database with db:setup).
#
# Examples:
#
#   movies = Movie.create([{ name: 'Star Wars' }, { name: 'Lord of the Rings' }])
#   Character.create(name: 'Luke', movie: movies.first)


# Create a default Community
default_community = Community.find_or_create_by!(name: "Terrastories") do |community|
  community.country = "United States of America"
  community.locale = "en"
  community.theme = Theme.create! do |theme|
    theme.active = true
    theme.sponsor_logos.attach(io: File.open('app/assets/images/rubyforgood.png'), filename: 'rubyforgood.png')
    theme.background_img.attach(io: File.open('app/assets/images/welcome-bg.jpg'), filename: 'welcome-bg.jpg')
  end
end

# Create Places
rfg2018 = Place.find_or_create_by(name: "Georgetown University", type_of_place: 'college campus', long: -77.073168, lat: 38.906302, region: "Washington DC", community: default_community)
rbtb2019 = Place.find_or_create_by(name: "NatureBridge Campus", type_of_place: 'nonprofit campus', long: -122.537419, lat: 37.832257, region: "California", community: default_community)

# Create Speakers
miranda = Speaker.find_or_create_by(name: "Miranda Wang", community: default_community)
kalimar = Speaker.find_or_create_by(name: "Kalimar Maia", community: default_community)
rudo = Speaker.find_or_create_by(name: "Rudo Kemper", community: default_community)
corinne = Speaker.find_or_create_by(name: "Corinne Henk", community: default_community)

# Create Stories
miranda_story = Story.find_or_create_by(title: "Miranda's testimonial",
                    desc: "Ruby for Good 2018 team lead Miranda Wang about why she values working on Terrastories.",
                    places: [rfg2018],
                    language: 'English',
                    permission_level: 0,
                    interview_location_id: rfg2018.id,
                    interviewer_id: corinne.id,
                    speakers: [miranda],
                    community: default_community)


rudo_story = Story.find_or_create_by(title: "Rudo's testimonial",
                    desc: "ACT program manager Rudo Kemper discusses why the organization decided to start building Terrastories to support local communities retain their oral history traditions.",
                    places: [rbtb2019],
                    language: 'English',
                    permission_level: 0,
                    interviewer_id: kalimar.id,
                    interview_location_id: rbtb2019.id,
                    speakers: [rudo],
                    community: default_community)

kalimar_story = Story.find_or_create_by(title: "Kalimar's testimonial",
                    desc: "Mapbox sales engineer Kalimar Maia on why it is important for a company like Mapbox to support open source projects like Terrastories.",
                    places: [rfg2018],
                    language: 'English',
                    permission_level: 1,
                    interviewer_id: miranda.id,
                    interview_location_id: rfg2018.id,
                    speakers: [kalimar],
                    community: default_community)

corinne_story = Story.find_or_create_by(title: "Corinne's testimonial",
                    desc: "Corinne Henk, Ruby by the Bay 2019 team lead, describes some of the challenges her team faced and what they managed to accomplish.",
                    places: [rbtb2019],
                    language: 'English',
                    permission_level: 0,
                    interviewer_id: rudo.id,
                    interview_location_id: rbtb2019.id,
                    speakers: [corinne],
                    community: default_community)

shared_story = Story.find_or_create_by(title: "Terrastories Team testimonial",
                    desc: "The team tells all",
                    places: [rfg2018],
                    language: 'English',
                    permission_level: 1,
                    interview_location_id: rfg2018.id,
                    speakers: [miranda, corinne, kalimar, rudo],
                    community: default_community)

# Create a default admin user
User.find_or_create_by!(email: 'admin@terrastories.com') do |admin|
  admin.password = 'terrastories'
  admin.password_confirmation = 'terrastories'
  admin.role = 2
  admin.community = default_community
end

# Create a example editor user
User.find_or_create_by!(email: 'editor@terrastories.com') do |admin|
  admin.password = 'terrastories'
  admin.password_confirmation = 'terrastories'
  admin.role = 1
  admin.community = default_community
end

# Create a example member user
User.find_or_create_by!(email: 'user@terrastories.com') do |admin|
  admin.password = 'terrastories'
  admin.password_confirmation = 'terrastories'
  admin.role = 0
  admin.community = default_community
end

# Create a example viewer user
User.find_or_create_by!(email: 'viewer@terrastories.com') do |user|
  user.password = 'terrastories'
  user.password_confirmation = 'terrastories'
  user.role = 3
  user.community = default_community
end

# Create another Community
another_community = Community.find_or_create_by!(name: "Ruby for Good") do |community|
  community.country = "United States of America"
  community.locale = "en"
end

# And community admin user
User.find_or_create_by!(email: 'admin@r4g.com') do |admin|
  admin.password = 'terrastories'
  admin.password_confirmation = 'terrastories'
  admin.role = 2
  admin.community = another_community
end

# Super Admin user for Terrastories
User.find_or_create_by!(email: "super@terrastories.com") do |admin|
  admin.password = 'terrastories'
  admin.password_confirmation = 'terrastories'
  admin.role = 100
  admin.super_admin = true
end

# Public user, not associated with Community
User.find_or_create_by!(email: "public@terrastories.com") do |admin|
  admin.password = 'terrastories'
  admin.password_confirmation = 'terrastories'
  admin.role = 100
end
