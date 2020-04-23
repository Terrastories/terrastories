FactoryBot.define do
  factory :story do
    title { "Rudo's testimonial" }
    desc  { "ACT program manager Rudo Kemper discusses why the organization decided to start building Terrastories to support local communities retain their oral history traditions." }
    language { 'English' }
    permission_level { 0 }

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
  end
end
