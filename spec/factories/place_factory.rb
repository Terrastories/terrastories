FactoryBot.define do
  factory :place do
    name { "Georgetown University" }
    type_of_place { "college campus" }
    long { -77.073168 }
    lat { 38.906302 }
    region { 'Washington DC' }
  end
end
