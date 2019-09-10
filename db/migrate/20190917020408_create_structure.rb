class CreateStructure < ActiveRecord::Migration[5.2]
  def change
    create_table "active_storage_attachments" do |t|
      t.string "name", null: false
      t.string "record_type", null: false
      t.bigint "record_id", null: false
      t.bigint "blob_id", null: false
      t.datetime "created_at", null: false
      t.index ["blob_id"], name: "index_active_storage_attachments_on_blob_id"
      t.index ["record_type", "record_id", "name", "blob_id"], name: "index_active_storage_attachments_uniqueness", unique: true
    end
  
    create_table "active_storage_blobs" do |t|
      t.string "key", null: false
      t.string "filename", null: false
      t.string "content_type"
      t.text "metadata"
      t.bigint "byte_size", null: false
      t.string "checksum", null: false
      t.datetime "created_at", null: false
      t.index ["key"], name: "index_active_storage_blobs_on_key", unique: true
    end
  
    create_table "places" do |t|
      t.string "name"
      t.string "type_of_place"
      t.datetime "created_at", null: false
      t.datetime "updated_at", null: false
      t.decimal "lat", precision: 10, scale: 6
      t.decimal "long", precision: 10, scale: 6
      t.string "region"
      t.string "description"
    end
  
    create_table "places_stories" do |t|
      t.bigint "story_id", null: false
      t.bigint "place_id", null: false
      t.index ["story_id", "place_id"], name: "index_places_stories_on_story_id_and_place_id"
    end
  
    create_table "speaker_stories" do |t|
      t.bigint "speaker_id", null: false
      t.bigint "story_id", null: false
    end
  
    create_table "speakers" do |t|
      t.string "name"
      t.string "photo"
      t.datetime "created_at", null: false
      t.datetime "updated_at", null: false
      t.datetime "birthdate"
      t.integer "birthplace_id"
      t.index ["birthplace_id"], name: "index_speakers_on_birthplace_id"
    end
  
    create_table "stories" do |t|
      t.string "title"
      t.text "desc"
      t.datetime "created_at", null: false
      t.datetime "updated_at", null: false
      t.integer "permission_level"
      t.datetime "date_interviewed"
      t.string "language"
      t.integer "interview_location_id"
      t.integer "interviewer_id"
    end
  
    create_table "users" do |t|
      t.string "email", default: "", null: false
      t.string "encrypted_password", default: "", null: false
      t.string "reset_password_token"
      t.datetime "reset_password_sent_at"
      t.datetime "remember_created_at"
      t.integer "sign_in_count", default: 0, null: false
      t.datetime "current_sign_in_at"
      t.datetime "last_sign_in_at"
      t.string "current_sign_in_ip"
      t.string "last_sign_in_ip"
      t.datetime "created_at", null: false
      t.datetime "updated_at", null: false
      t.integer "role"
      t.index ["email"], name: "index_users_on_email", unique: true
      t.index ["reset_password_token"], name: "index_users_on_reset_password_token", unique: true
    end
  end
end
