FactoryBot.define do
  factory :speaker do
    # t.string "name"
    name { 'Alice' }

    # t.string "photo"
    photo { 'alice.jpg' }

    # t.string "region"
    region { 'Wonderland' }

    # t.string "community"
    community { 'Humans' }

    # t.datetime "created_at", null: false
    # t.datetime "updated_at", null: false
  end
end
