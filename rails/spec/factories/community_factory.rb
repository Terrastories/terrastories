FactoryBot.define do
  factory :community do
    name { "Matawai "}
    locale { "mat" }
    country { "Suriname" }
    slug { name.gsub(/\s+/, "").underscore }
  end
end
