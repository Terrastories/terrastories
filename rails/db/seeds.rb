# This file should contain all the record creation needed to seed the database with its default values.
# The data can then be loaded with the rails db:seed command (or created alongside the database with db:setup).
#
# Examples:
#
#   movies = Movie.create([{ name: 'Star Wars' }, { name: 'Lord of the Rings' }])
#   Character.create(name: 'Luke', movie: movies.first)

# Create Places
imw2020 = Place.find_or_create_by(name: "Saskatchewan", type_of_place: 'online', long: -106.037998, lat: 54.170027, region: "Saskatchewan (Canada)")

# Create Speakers
imwcanada = Speaker.find_or_create_by(name: "IMW Canada")

# Create Stories
imw2020_story = Story.find_or_create_by(title: "The story of #20202020.",
                    desc: "Introducing the very first Virtual Indigenous Mapping Workshop. For the first time ever, IMW participants can develop their skills, with cutting edge geospatial technologies, from anywhere around the globe. Learn to redefine Indigenous landscapes from Indigenous mapping experts. Develop hands-on skills from leading industry professionals including Esri, Google, NASA, Mapbox and more. Join the Indigenous Mapping Collective and have unprecedented access to all IMW course materials and exclusive new content posted throughout the year.",
                    places: [imw2020],
                    language: 'English',
                    permission_level: 0,
                    interview_location_id: imw2020.id,
                    interviewer_id: imwcanada.id,
                    speakers: [imwcanada])


# Create a default admin user
User.find_or_create_by!(email: 'terrastories@indigenousmaps.com') do |admin|  
  admin.password = 'mapsthatroar'
  admin.password_confirmation = 'mapsthatroar'
  admin.role = 1
end
