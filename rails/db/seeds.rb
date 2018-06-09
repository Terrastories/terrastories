# This file should contain all the record creation needed to seed the database with its default values.
# The data can then be loaded with the rails db:seed command (or created alongside the database with db:setup).
#
# Examples:
#
#   movies = Movie.create([{ name: 'Star Wars' }, { name: 'Lord of the Rings' }])
#   Character.create(name: 'Luke', movie: movies.first)
Point.create(title: "Ocean", lng: -55, lat: 4, region: "Kumiade")
Point.create(title: "Pond", lng: -55, lat: 5, region: "Kumiade")
Point.create(title: "Flowing Water", lng: -56, lat: 5, region: "Tukumutu")
Point.create(title: "Flaming Forest", lng: -57, lat: 4, region: "Kwata Ede")
Point.create(title: "Sacred Forest Tree", lng: -57, lat: 5, region: "Tukumutu")

Story.create(title: "Fa di Saamaka sembe bi haba a beligi",
             desc: "Het is al geruime tijd een bekend gegeven dat een lezer, tijdens het bekijken van de layout van een pagina, afgeleid wordt door de tekstuele inhoud. Het belangrijke punt van het gebruik van Lorem Ipsum is dat het uit een min of meer normale verdeling van letters bestaat, in tegenstelling tot 'Hier uw tekst, hier uw tekst' wat het tot min of meer leesbaar nederlands maakt.",
             speaker: "Josef Dennerts",
             point: Point.first)

Story.create(title: "Di twaalfu lampeesi fu Toido",
             desc: "Veel desktop publishing pakketten en web pagina editors gebruiken tegenwoordig Lorem Ipsum als hun standaard model tekst, en een zoekopdracht naar 'lorem ipsum' ontsluit veel websites die nog in aanbouw zijn. Verscheidene versies hebben zich ontwikkeld in de loop van de jaren, soms per ongeluk soms expres (ingevoegde humor en dergelijke).",
             speaker: "William Anipa",
             point: Point.first)

Story.create(title: "Fa di gaan sembe veloisi go aki",
             desc: "r zijn vele variaties van passages van Lorem Ipsum beschikbaar maar het merendeel heeft te lijden gehad van wijzigingen in een of andere vorm, door ingevoegde humor of willekeurig gekozen woorden die nog niet half geloofwaardig ogen.",
             speaker: "Speakers Name",
             point: Point.second)

Story.create(title: "Mama Tjowa",
             desc: "Als u een passage uit Lorum Ipsum gaat gebruiken dient u zich ervan te verzekeren dat er niets beschamends midden in de tekst verborgen zit. Alle Lorum Ipsum generators op Internet hebben de eigenschap voorgedefinieerde stukken te herhalen waar nodig zodat dit de eerste echte generator is op internet.",
             speaker: "Dora Flink",
             point: Point.third)

Story.create(title: "Fa di Kwinti nengeb bi feti ku Matawai sembe",
             desc: "In tegenstelling tot wat algemeen aangenomen wordt is Lorem Ipsum niet zomaar willekeurige tekst. het heeft zijn wortels in een stuk klassieke latijnse literatuur uit 45 v.Chr. en is dus meer dan 2000 jaar oud.",
             speaker: "Oom Bree",
             point: Point.fourth)
