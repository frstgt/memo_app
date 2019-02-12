# This file is auto-generated from the current state of the database. Instead
# of editing this file, please use the migrations feature of Active Record to
# incrementally modify your database, and then regenerate this schema definition.
#
# Note that this schema.rb definition is the authoritative source for your
# database schema. If you need to create the application database on another
# system, you should be using db:schema:load, not running all the migrations
# from scratch. The latter is a flawed and unsustainable approach (the more migrations
# you'll amass, the slower it'll run and the greater likelihood for issues).
#
# It's strongly recommended that you check this file into your version control system.

ActiveRecord::Schema.define(version: 20190212115604) do

  create_table "memos", force: :cascade do |t|
    t.integer "number"
    t.integer "note_id"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.text "content"
    t.string "picture"
    t.index ["note_id", "number"], name: "index_memos_on_note_id_and_number"
    t.index ["note_id"], name: "index_memos_on_note_id"
  end

  create_table "notes", force: :cascade do |t|
    t.string "title"
    t.text "description"
    t.integer "user_id"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.integer "pen_name_id"
    t.index ["pen_name_id"], name: "index_notes_on_pen_name_id"
    t.index ["user_id", "updated_at"], name: "index_notes_on_user_id_and_updated_at"
    t.index ["user_id"], name: "index_notes_on_user_id"
  end

  create_table "pen_names", force: :cascade do |t|
    t.string "name"
    t.text "description"
    t.integer "user_id"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.string "picture"
    t.index ["name"], name: "index_pen_names_on_name", unique: true
    t.index ["user_id", "updated_at"], name: "index_pen_names_on_user_id_and_updated_at"
    t.index ["user_id"], name: "index_pen_names_on_user_id"
  end

  create_table "users", force: :cascade do |t|
    t.string "name"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.string "password_digest"
    t.index ["name"], name: "index_users_on_name", unique: true
  end

end
