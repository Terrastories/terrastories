FactoryBot.define do
  factory :story do
    title { "Rudo's testimonial" }
    desc  { "ACT program manager Rudo Kemper discusses why the organization decided to start building Terrastories to support local communities retain their oral history traditions." }
    language { 'English' }
    permission_level { 0 }
    association :interviewer, factory: :speaker
    association :interview_location, factory: :place
  end
end
