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

Story.find_or_create_by(title: "Miranda's testimonial",
                     desc: "Ruby for Good 2018 team lead Miranda Wang about why she values working on Terrastories.",
                     speaker: miranda,
                     point: rfg2018,
                     permission_level: 0)

Story.find_or_create_by(title: "Rudo's testimonial",
                     desc: "ACT program manager Rudo Kemper discusses why the organization decided to start building Terrastories to support local communities retain their oral history traditions.",
                     speaker: rudo,
                     point: rbtb2019,
                     permission_level: 0)

Story.find_or_create_by(title: "Kalimar's testimonial",
                     desc: "Mapbox sales engineer Kalimar Maia on why it is important for a company like Mapbox to support open source projects like Terrastories.",
                     speaker: kalimar,
                     point: rfg2018,
                     permission_level: 1)
					 
Story.find_or_create_by(title: "Corinne's testimonial",
                     desc: "Corinne Henk, Ruby by the Bay 2019 team lead, describes some of the challenges her team faced and what they managed to accomplish.",
                     speaker: corinne,
                     point: rbtb2019,
                     permission_level: 0)					 
                     
User.find_or_create_by!(email: 'admin@terrastories.com') do |admin|  
  admin.password = 'terrastories'
  admin.password_confirmation = 'terrastories'
  admin.role = 1
end
