FactoryBot.define do
  factory :community do
    name { "Matawai "}
    locale { "mat" }
    country { "Suriname" }

    factory :public_community do
      public { true }
      slug { }
    end

    transient do
      stories {[]}
    end

    after(:create) do |community, evaluator|
      community.stories << evaluator.stories
    end
  end
end
