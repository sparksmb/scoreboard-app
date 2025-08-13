# This file is auto-generated from the current state of the database. Instead
# of editing this file, please use the migrations feature of Active Record to
# incrementally modify your database, and then regenerate this schema definition.
#
# This file is the source Rails uses to define your schema when running `bin/rails
# db:schema:load`. When creating a new database, `bin/rails db:schema:load` tends to
# be faster and is potentially less error prone than running all of your
# migrations from scratch. Old migrations may fail to apply correctly if those
# migrations use external dependencies or application code.
#
# It's strongly recommended that you check this file into your version control system.

ActiveRecord::Schema[7.2].define(version: 2025_08_13_021300) do
  # These are extensions that must be enabled in order to support this database
  enable_extension "plpgsql"

  create_table "active_storage_attachments", force: :cascade do |t|
    t.string "name", null: false
    t.string "record_type", null: false
    t.bigint "record_id", null: false
    t.bigint "blob_id", null: false
    t.datetime "created_at", null: false
    t.index ["blob_id"], name: "index_active_storage_attachments_on_blob_id"
    t.index ["record_type", "record_id", "name", "blob_id"], name: "index_active_storage_attachments_uniqueness", unique: true
  end

  create_table "active_storage_blobs", force: :cascade do |t|
    t.string "key", null: false
    t.string "filename", null: false
    t.string "content_type"
    t.text "metadata"
    t.string "service_name", null: false
    t.bigint "byte_size", null: false
    t.string "checksum"
    t.datetime "created_at", null: false
    t.index ["key"], name: "index_active_storage_blobs_on_key", unique: true
  end

  create_table "active_storage_variant_records", force: :cascade do |t|
    t.bigint "blob_id", null: false
    t.string "variation_digest", null: false
    t.index ["blob_id", "variation_digest"], name: "index_active_storage_variant_records_uniqueness", unique: true
  end

  create_table "games", force: :cascade do |t|
    t.bigint "organization_id", null: false
    t.bigint "home_team_id", null: false
    t.bigint "visitor_team_id", null: false
    t.datetime "game_date", null: false
    t.string "location"
    t.text "description"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["game_date"], name: "index_games_on_game_date"
    t.index ["home_team_id"], name: "index_games_on_home_team_id"
    t.index ["organization_id", "game_date"], name: "index_games_on_organization_id_and_game_date"
    t.index ["organization_id"], name: "index_games_on_organization_id"
    t.index ["visitor_team_id"], name: "index_games_on_visitor_team_id"
  end

  create_table "organizations", force: :cascade do |t|
    t.string "name", null: false
    t.boolean "active", default: true, null: false
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["active"], name: "index_organizations_on_active"
    t.index ["name"], name: "index_organizations_on_name", unique: true
  end

  create_table "scoreboards", force: :cascade do |t|
    t.bigint "game_id", null: false
    t.string "type", null: false
    t.integer "home_score", default: 0
    t.integer "visitor_score", default: 0
    t.integer "quarter", default: 1
    t.string "time_remaining", default: "15:00"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.integer "home_timeouts_remaining", default: 3
    t.integer "visitor_timeouts_remaining", default: 3
    t.index ["game_id"], name: "index_scoreboards_on_game_id"
    t.index ["type"], name: "index_scoreboards_on_type"
  end

  create_table "teams", force: :cascade do |t|
    t.string "name", null: false
    t.string "primary_color"
    t.string "secondary_color"
    t.bigint "organization_id", null: false
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.string "mascot"
    t.index ["organization_id", "name"], name: "index_teams_on_organization_id_and_name", unique: true
    t.index ["organization_id"], name: "index_teams_on_organization_id"
  end

  create_table "users", force: :cascade do |t|
    t.string "email", default: "", null: false
    t.string "encrypted_password", default: "", null: false
    t.string "reset_password_token"
    t.datetime "reset_password_sent_at"
    t.datetime "remember_created_at"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.string "first_name", null: false
    t.string "last_name", null: false
    t.bigint "organization_id"
    t.boolean "admin", default: false, null: false
    t.index ["email"], name: "index_users_on_email", unique: true
    t.index ["organization_id"], name: "index_users_on_organization_id"
    t.index ["reset_password_token"], name: "index_users_on_reset_password_token", unique: true
  end

  add_foreign_key "active_storage_attachments", "active_storage_blobs", column: "blob_id"
  add_foreign_key "active_storage_variant_records", "active_storage_blobs", column: "blob_id"
  add_foreign_key "games", "organizations"
  add_foreign_key "games", "teams", column: "home_team_id"
  add_foreign_key "games", "teams", column: "visitor_team_id"
  add_foreign_key "scoreboards", "games"
  add_foreign_key "teams", "organizations"
  add_foreign_key "users", "organizations"
end
