FactoryBot.define do
  factory :community do
    name { "Matawai "}
    locale { "mat" }
    country { "Suriname" }

    factory :public_community do
      public { true }
      slug { }
    end
  end
end
