FactoryBot.define do
  factory :place do
    name { "Georgetown University" }
    type_of_place { "college campus" }
    long { -77.073168 }
    lat { 38.906302 }
    region { 'Washington DC' }
    community

    factory :place_with_stories do
      transient do
        story_count { 5 }
      end

      stories do
        Array.new(story_count) { association(:story_with_speakers, speaker_count: 1, places: [instance]) }
      end
    end
  end
end
