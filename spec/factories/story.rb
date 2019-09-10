FactoryBot.define do
  factory :story do
    # t.string "title"
    title { 'The Mad Hatter' }

    # t.text "desc"
    desc { "We're all mad here!" }

    # t.integer "permission_level"
    permission_level { 0 }

    # t.bigint "speaker_id"
    speaker { create(:speaker) }

    # t.bigint "point_id"
    point { create(:point) }

    # t.datetime "created_at", null: false
    # t.datetime "updated_at", null: false
  end
end
