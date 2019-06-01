# This file should contain all the record creation needed to seed the database with its default values.
# The data can then be loaded with the rails db:seed command (or created alongside the database with db:setup).
#
# Examples:
#
#   movies = Movie.create([{ name: 'Star Wars' }, { name: 'Lord of the Rings' }])
#   Character.create(name: 'Luke', movie: movies.first)
georgetown = Place.find_or_create_by(name: 'Georgetown University', type_of_place: 'college campus');
naturebridge = Place.find_or_create_by(name: 'NatureBridge Campus', type_of_place: 'nonprofit campus');
rfg2018 = Point.find_or_create_by(title: "Ruby For Good 2018", lng: -77.073168, lat: 38.906302, region: "Washington DC", place: georgetown)
rbtb2019 = Point.find_or_create_by(title: "Ruby By The Bay 2019", lng: -122.537419, lat: 37.832257, region: "California", place: naturebridge)
miranda = Speaker.find_or_create_by(name: "Miranda Wang")
kalimar = Speaker.find_or_create_by(name: "Kalimar Maia")
rudo = Speaker.find_or_create_by(name: "Rudo Kemper")
corinne = Speaker.find_or_create_by(name: "Corinne Henk")

miranda_story = Story.find_or_create_by(title: "Miranda's testimonial",
                     desc: "Ruby for Good 2018 team lead Miranda Wang about why she values working on Terrastories.",
                     point: rfg2018,
                     permission_level: 0)


rudo_story = Story.find_or_create_by(title: "Rudo's testimonial",
                     desc: "ACT program manager Rudo Kemper discusses why the organization decided to start building Terrastories to support local communities retain their oral history traditions.",
                     point: rbtb2019,
                     permission_level: 0)

kalimar_story = Story.find_or_create_by(title: "Kalimar's testimonial",
                     desc: "Mapbox sales engineer Kalimar Maia on why it is important for a company like Mapbox to support open source projects like Terrastories.",
                     point: rfg2018,
                     permission_level: 1)

corinne_story = Story.find_or_create_by(title: "Corinne's testimonial",
                     desc: "Corinne Henk, Ruby by the Bay 2019 team lead, describes some of the challenges her team faced and what they managed to accomplish.",
                     point: rbtb2019,
                     permission_level: 0)

shared_story = Story.find_or_create_by(title: "Terrastories Team testimonial",
                    desc: "The team tells all",
                    point: rfg2018,
                    permission_level: 1)

SpeakerStory.find_or_create_by(speaker_id: miranda.id, story_id: miranda_story.id)
SpeakerStory.find_or_create_by(speaker_id: rudo.id, story_id: rudo_story.id)
SpeakerStory.find_or_create_by(speaker_id: kalimar.id, story_id: kalimar_story.id)
SpeakerStory.find_or_create_by(speaker_id: corinne.id, story_id: corinne_story.id)

SpeakerStory.find_or_create_by(speaker_id: miranda.id, story_id: shared_story.id)
SpeakerStory.find_or_create_by(speaker_id: rudo.id,    story_id: shared_story.id)
SpeakerStory.find_or_create_by(speaker_id: kalimar.id, story_id: shared_story.id)
SpeakerStory.find_or_create_by(speaker_id: corinne.id, story_id: shared_story.id)
                     
User.find_or_create_by!(email: 'admin@terrastories.com') do |admin|  
  admin.password = 'terrastories'
  admin.password_confirmation = 'terrastories'
  admin.role = 1
end
