# This file should contain all the record creation needed to seed the database with its default values.
# The data can then be loaded with the rails db:seed command (or created alongside the database with db:setup).
#
# Examples:
#
#   movies = Movie.create([{ name: 'Star Wars' }, { name: 'Lord of the Rings' }])
#   Character.create(name: 'Luke', movie: movies.first)

# Create Places
rfg2018 = Place.find_or_create_by(name: "Georgetown University", type_of_place: 'college campus', long: -77.073168, lat: 38.906302, region: "Washington DC")
rbtb2019 = Place.find_or_create_by(name: "NatureBridge Campus", type_of_place: 'nonprofit campus', long: -122.537419, lat: 37.832257, region: "California")

# Create Speakers
miranda = Speaker.find_or_create_by(name: "Miranda Wang")
kalimar = Speaker.find_or_create_by(name: "Kalimar Maia")
rudo = Speaker.find_or_create_by(name: "Rudo Kemper")
corinne = Speaker.find_or_create_by(name: "Corinne Henk")

# Create Stories
miranda_story = Story.find_or_create_by(title: "Miranda's testimonial",
                    desc: "Ruby for Good 2018 team lead Miranda Wang about why she values working on Terrastories.",
                    places: [rfg2018],
                    language: 'English',
                    permission_level: 0,
                    interview_location_id: rfg2018.id,
                    interviewer_id: corinne.id) do |story|
                      file = File.open(Rails.root.join('app', 'assets', 'videos', 'school_story.mp4'))
                      story.media.attach(io: file, filename: 'school_story')
                    end


rudo_story = Story.find_or_create_by(title: "Rudo's testimonial",
                    desc: "ACT program manager Rudo Kemper discusses why the organization decided to start building Terrastories to support local communities retain their oral history traditions.",
                    places: [rbtb2019],
                    language: 'English',
                    permission_level: 0,
                    interviewer_id: kalimar.id,
                    interview_location_id: rbtb2019.id) do |story|
                      file = File.open(Rails.root.join('app', 'assets', 'videos', 'tanzania.mp4'))
                      story.media.attach(io: file, filename: 'tanzania')
                    end

kalimar_story = Story.find_or_create_by(title: "Kalimar's testimonial",
                    desc: "Mapbox sales engineer Kalimar Maia on why it is important for a company like Mapbox to support open source projects like Terrastories.",
                    places: [rfg2018],
                    language: 'English',
                    permission_level: 1,
                    interviewer_id: miranda.id,
                    interview_location_id: rfg2018.id) do |story|
                      file = File.open(Rails.root.join('app', 'assets', 'videos', 'fisherman_story.mp4'))
                      story.media.attach(io: file, filename: 'fisherman')
                    end

corinne_story = Story.find_or_create_by(title: "Corinne's testimonial",
                    desc: "Corinne Henk, Ruby by the Bay 2019 team lead, describes some of the challenges her team faced and what they managed to accomplish.",
                    places: [rbtb2019],
                    language: 'English',
                    permission_level: 0,
                    interviewer_id: rudo.id,
                    interview_location_id: rbtb2019.id) do |story|
                      file = File.open(Rails.root.join('app', 'assets', 'videos', 'samba.mp4'))
                      story.media.attach(io: file, filename: 'samba')
                    end

shared_story = Story.find_or_create_by(title: "Terrastories Team testimonial",
                    desc: "The team tells all",
                    places: [rfg2018],
                    language: 'English',
                    permission_level: 1,
                    interview_location_id: rfg2018.id) do |story|
                      file = File.open(Rails.root.join('app', 'assets', 'videos', 'salt.mp4'))
                      story.media.attach(io: file, filename: 'salt')
                    end

# Associate speakers with their stories
SpeakerStory.find_or_create_by(speaker_id: miranda.id, story_id: miranda_story.id)
SpeakerStory.find_or_create_by(speaker_id: rudo.id, story_id: rudo_story.id)
SpeakerStory.find_or_create_by(speaker_id: kalimar.id, story_id: kalimar_story.id)
SpeakerStory.find_or_create_by(speaker_id: corinne.id, story_id: corinne_story.id)

# Associate all speakers w/ the shared story
SpeakerStory.find_or_create_by(speaker_id: miranda.id, story_id: shared_story.id)
SpeakerStory.find_or_create_by(speaker_id: rudo.id,    story_id: shared_story.id)
SpeakerStory.find_or_create_by(speaker_id: kalimar.id, story_id: shared_story.id)
SpeakerStory.find_or_create_by(speaker_id: corinne.id, story_id: shared_story.id)

# Create a default admin user
User.find_or_create_by!(email: 'admin@terrastories.com') do |admin|  
  admin.password = 'terrastories'
  admin.password_confirmation = 'terrastories'
  admin.role = 1
end
