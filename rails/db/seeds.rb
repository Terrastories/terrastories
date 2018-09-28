# This file should contain all the record creation needed to seed the database with its default values.
# The data can then be loaded with the rails db:seed command (or created alongside the database with db:setup).
#
# Examples:
#
#   movies = Movie.create([{ name: 'Star Wars' }, { name: 'Lord of the Rings' }])
#   Character.create(name: 'Luke', movie: movies.first)
Place.create(name: 'Afitimamau', type_of_place: 'dang');
Place.create(name: 'Amenusu', type_of_place: 'kampu');
Place.create(name: 'Bakaafeeti', type_of_place: 'hila');
Point.create(title: "Ocean", lng: -55.2452415, lat: 3.827618371, region: "Kumiade", place: Place.first)
Point.create(title: "Pond", lng: -55.23122, lat: 5.3351, region: "Kumiade", place: Place.second)
Point.create(title: "Flowing Water", lng: -56.875, lat: 5.8881435, region: "Tukumutu", place: Place.third)
Point.create(title: "Flaming Forest", lng: -56.12357544, lat: 3.1156739, region: "Kwata Ede", place: Place.fourth)
Point.create(title: "Sacred Forest Tree", lng: -56.87875645, lat: 4.897634332, region: "Tukumutu", place: Place.first)
Speaker.create(name: "Speaker Name")

Story.create(title: "Fa di Saamaka sembe bi haba a beligi",
             desc: "Het is al geruime tijd een bekend gegeven dat een lezer, tijdens het bekijken van de layout van een pagina, afgeleid wordt door de tekstuele inhoud. Het belangrijke punt van het gebruik van Lorem Ipsum is dat het uit een min of meer normale verdeling van letters bestaat, in tegenstelling tot 'Hier uw tekst, hier uw tekst' wat het tot min of meer leesbaar nederlands maakt.",
             speaker: Speaker.first,
             point: Point.first,
             permission_level: 0)

Story.create(title: "Di twaalfu lampeesi fu Toido",
             desc: "Veel desktop publishing pakketten en web pagina editors gebruiken tegenwoordig Lorem Ipsum als hun standaard model tekst, en een zoekopdracht naar 'lorem ipsum' ontsluit veel websites die nog in aanbouw zijn. Verscheidene versies hebben zich ontwikkeld in de loop van de jaren, soms per ongeluk soms expres (ingevoegde humor en dergelijke).",
             speaker: Speaker.first,
             point: Point.first,
             permission_level: 0)

Story.create(title: "Fa di gaan sembe veloisi go aki",
             desc: "r zijn vele variaties van passages van Lorem Ipsum beschikbaar maar het merendeel heeft te lijden gehad van wijzigingen in een of andere vorm, door ingevoegde humor of willekeurig gekozen woorden die nog niet half geloofwaardig ogen.",
             speaker: Speaker.first,
             point: Point.second,
             permission_level: 1)

Story.create(title: "Mama Tjowa",
             desc: "Als u een passage uit Lorum Ipsum gaat gebruiken dient u zich ervan te verzekeren dat er niets beschamends midden in de tekst verborgen zit. Alle Lorum Ipsum generators op Internet hebben de eigenschap voorgedefinieerde stukken te herhalen waar nodig zodat dit de eerste echte generator is op internet.",
             speaker: Speaker.first,
             point: Point.third,
             permission_level: 1)

Story.create(title: "Fa di Kwinti nengeb bi feti ku Matawai sembe",
             desc: "In tegenstelling tot wat algemeen aangenomen wordt is Lorem Ipsum niet zomaar willekeurige tekst. het heeft zijn wortels in een stuk klassieke latijnse literatuur uit 45 v.Chr. en is dus meer dan 2000 jaar oud.",
             speaker: Speaker.first,
             point: Point.fourth,
             permission_level: 1)

User.create(email: 'admin@terrastories.com',
            password: 'password',
            role: 1)
