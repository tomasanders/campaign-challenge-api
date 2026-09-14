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

ActiveRecord::Schema[8.1].define(version: 2026_09_14_030000) do
  # These are extensions that must be enabled in order to support this database
  enable_extension "pg_catalog.plpgsql"

  create_table "participants", force: :cascade do |t|
    t.integer "age", null: false
    t.string "country_code", null: false
    t.datetime "created_at", null: false
    t.string "email", null: false
    t.string "first_name", null: false
    t.string "last_name", null: false
    t.boolean "marketing_opt_in", null: false
    t.datetime "updated_at", null: false
    t.index "lower((email)::text)", name: "index_participants_on_lower_email", unique: true
  end

  create_table "scores", force: :cascade do |t|
    t.datetime "created_at", null: false
    t.bigint "duration_ms", null: false
    t.bigint "participant_id", null: false
    t.datetime "played_at", null: false
    t.integer "score", null: false
    t.datetime "updated_at", null: false
    t.index ["participant_id"], name: "index_scores_on_participant_id", unique: true
    t.check_constraint "duration_ms > 0", name: "scores_duration_ms_positive"
    t.check_constraint "score > 0", name: "scores_score_positive"
  end

  add_foreign_key "scores", "participants"
end
