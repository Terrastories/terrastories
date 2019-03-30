FactoryBot.define do
  factory :place do
    # t.string "name"
    name { 'Wonderland' }

    # t.string "type_of_place"
    type_of_place { 'Magical' }

    # t.datetime "created_at", null: false
    # t.datetime "updated_at", null: false
  end
end
