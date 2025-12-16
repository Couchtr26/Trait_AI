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

ActiveRecord::Schema[8.1].define(version: 2025_11_30_000809) do
  # These are extensions that must be enabled in order to support this database
  enable_extension "pg_catalog.plpgsql"

  create_table "messages", force: :cascade do |t|
    t.text "ai_response"
    t.text "body"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.bigint "user_id", null: false
    t.index ["user_id"], name: "index_messages_on_user_id"
  end

  create_table "user_memories", force: :cascade do |t|
    t.text "content"
    t.datetime "created_at", null: false
    t.integer "importance"
    t.string "memory_type"
    t.datetime "updated_at", null: false
    t.bigint "user_id", null: false
    t.index ["user_id"], name: "index_user_memories_on_user_id"
  end

  create_table "users", force: :cascade do |t|
    t.integer "calmness"
    t.datetime "cooldown_until"
    t.datetime "created_at", null: false
    t.integer "curiosity"
    t.string "email"
    t.integer "empathy"
    t.integer "humor"
    t.integer "logic"
    t.string "password_digest"
    t.datetime "updated_at", null: false
  end

  add_foreign_key "messages", "users"
  add_foreign_key "user_memories", "users"
end
