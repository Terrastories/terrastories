FactoryBot.define do
  factory :story do
    title { "Rudo's testimonial" }
    desc  { "ACT program manager Rudo Kemper discusses why the organization decided to start building Terrastories to support local communities retain their oral history traditions." }
    language { 'English' }
    permission_level { 0 }
    community
    story_pinned { false }

    trait :with_interviewer do
      after(:build) do |story|
        story.interviewer << FactoryBot.build(:speaker)
        story.interview_location << FactoryBot.build(:place)

      end
    end

    trait :with_speakers do
      after(:build) do |story|
        story.speakers = FactoryBot.build_list(:speaker, 2)
      end
    end

    trait :with_places do
      after(:build) do |story|
        story.places = FactoryBot.build_list(:place, 1)
      end
    end

    factory :story_with_speakers do
      transient do
        speaker_count { 2 }
      end

      speakers do
        Array.new(speaker_count) { association(:speaker, community: instance.community) }
      end
    end
  end
end
