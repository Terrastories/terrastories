# This file should contain all the record creation needed to seed the database with its default values.
# The data can then be loaded with the rails db:seed command (or created alongside the database with db:setup).
#
# Examples:
#
#   movies = Movie.create([{ name: 'Star Wars' }, { name: 'Lord of the Rings' }])
#   Character.create(name: 'Luke', movie: movies.first)

# Super Admin user for Terrastories
User.find_or_create_by!(email: "super@terrastories.io") do |admin|
  admin.username = 'terrastories-super'
  admin.password = 'terrastories'
  admin.password_confirmation = 'terrastories'
  admin.role = 100
  admin.super_admin = true
end

# Create an example Community
example_community = Community.find_or_create_by!(name: "Ruby for Good") do |community|
  community.country = "Global"
  community.locale = "en"
  community.theme = Theme.create! do |theme|
    theme.active = true
    theme.sponsor_logos.attach(io: File.open('app/assets/images/rubyforgood.png'), filename: 'rubyforgood.png')
    theme.background_img.attach(io: File.open('app/assets/images/welcome-bg.jpg'), filename: 'welcome-bg.jpg')
  end
end

# Create Places
rfg2018 = Place.find_or_create_by(name: "Georgetown University", type_of_place: 'college campus', long: -77.073168, lat: 38.906302, region: "Washington DC", community: example_community)
rbtb2019 = Place.find_or_create_by(name: "NatureBridge Campus", type_of_place: 'nonprofit campus', long: -122.537419, lat: 37.832257, region: "California", community: example_community)
pusugrunu = Place.find_or_create_by(name: "Pusugrunu village", type_of_place: 'village', long: -55.788083, lat: 4.396921, region: "Suriname", community: example_community)
null_island = Place.find_or_create_by(name: "Null island", type_of_place: 'the internet', long: 0, lat: 0, region: "Atlantic Ocean", community: example_community)

# Create Speakers
miranda = Speaker.find_or_create_by(name: "Miranda Wang", community: example_community)
kalimar = Speaker.find_or_create_by(name: "Kalimar Maia", community: example_community)
jason = Speaker.find_or_create_by(name: "Jason Hinebaugh", community: example_community)
corinne = Speaker.find_or_create_by(name: "Corinne Henk", community: example_community)
rudo = Speaker.find_or_create_by(name: "Rudo Kemper", community: example_community)
ian = Speaker.find_or_create_by(name: "Ian Norris", community: example_community)
mae = Speaker.find_or_create_by(name: "Mae Beale", community: example_community)
laura = Speaker.find_or_create_by(name: "Laura Mosher", community: example_community)


# Create Stories
rfg2019_story = Story.joins(:places, :speakers).find_or_create_by(title: "Ruby for Good 2018",
                    desc: "Ruby for Good 2018 team leads Miranda Wang and Jason Hinebaugh about why they wanted to help steward Terrastories.",
                    places: [rfg2018],
                    language: 'English',
                    permission_level: 0,
                    interview_location_id: rfg2018.id,
                    interviewer_id: corinne.id,
                    speakers: [miranda, jason],
                    community: example_community)


matawai_story = Story.joins(:places, :speakers).find_or_create_by(title: "Terrastories for the Matawai",
                    desc: "Kalimar Maia and Rudo Kemper describe what it was like to bring Terrastories to the Matawai in Pusugrunu, Suriname for the first time, in 2018.",
                    places: [pusugrunu],
                    language: 'English',
                    permission_level: 0,
                    interviewer_id: jason.id,
                    interview_location_id: pusugrunu.id,
                    speakers: [rudo, kalimar],
                    community: example_community)

rbtb2019_story = Story.joins(:places, :speakers).find_or_create_by(title: "Ruby by the Bay 2019",
                    desc: "Corinne Henk, Ruby by the Bay 2019 team lead, describes some of the challenges her team faced and what they managed to accomplish, in conversation with Rudo Kemper and Kalimar Maia.",
                    places: [rbtb2019],
                    language: 'English',
                    permission_level: 0,
                    interviewer_id: rudo.id,
                    interview_location_id: rbtb2019.id,
                    speakers: [corinne, rudo, kalimar],
                    community: example_community)

rbtb2020_story = Story.joins(:places, :speakers).find_or_create_by(title: "Ruby by the Bay 2020",
                    desc: "Ruby by the Bay 2020 team leads Ian Norris and Mae Beale on remotely stewarding a volunteer team from Ruby for Good, during the Covid-19 pandemic.",
                    places: [null_island],
                    language: 'English',
                    permission_level: 0,
                    interview_location_id: null_island.id,
                    speakers: [ian, mae],
                    community: example_community)

atalm2022_story = Story.joins(:places, :speakers).find_or_create_by(title: "ATALM 2022",
                    desc: "Terrastories stewards Laura Mosher and Rudo Kemper on developing Terrastories for a project funded by the Association of Tribal Archives, Libraries, and Museums",
                    places: [null_island],
                    language: 'English',
                    permission_level: 1,
                    interview_location_id: null_island.id,
                    speakers: [laura, rudo],
                    community: example_community)

# Create an admin user for example community
User.find_or_create_by!(email: 'admin@terrastories.io') do |admin|
  admin.username = 'terrastories-admin'
  admin.password = 'terrastories'
  admin.password_confirmation = 'terrastories'
  admin.role = 2
  admin.community = example_community
end

# Create an editor user for example community
User.find_or_create_by!(email: 'editor@terrastories.io') do |admin|
  admin.username = 'terrastories-editor'
  admin.password = 'terrastories'
  admin.password_confirmation = 'terrastories'
  admin.role = 1
  admin.community = example_community
end

# Create a member user for example community
User.find_or_create_by!(email: 'user@terrastories.io') do |admin|
  admin.username = 'terrastories-user'
  admin.password = 'terrastories'
  admin.password_confirmation = 'terrastories'
  admin.role = 0
  admin.community = example_community
end

# Create a viewer user for example community
User.find_or_create_by!(email: 'viewer@terrastories.io') do |user|
  user.username = 'terrastories-viewer'
  user.password = 'terrastories'
  user.password_confirmation = 'terrastories'
  user.role = 3
  user.community = example_community
end

# Public user, not associated with Community
User.find_or_create_by!(email: "public@terrastories.io") do |admin|
  admin.username = 'terrastories-public'
  admin.password = 'terrastories'
  admin.password_confirmation = 'terrastories'
  admin.role = 100
end
