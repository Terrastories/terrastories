FactoryBot.define do
  factory :point do
    # t.string "title"
    title { 'Jabberwocky' }

    # t.decimal "lng", precision: 10, scale: 6
    lng { BigDecimal('42.0') }

    # t.decimal "lat", precision: 10, scale: 6
    lat { BigDecimal('42.0') }

    # t.string "region"
    region { 'Wonderland' }

    # t.integer "place_id"
    place { create(:place) }

    # t.datetime "created_at", null: false
    # t.datetime "updated_at", null: false
  end
end
